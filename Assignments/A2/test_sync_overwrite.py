import json
import os
import socket
import tempfile
import threading
import time
import unittest
from unittest.mock import patch

from fileSynchronizer import Buffer, FileSynchronizer


class NoOpTimer:
    def __init__(self, *_args, **_kwargs):
        pass

    def start(self):
        pass


class TestSyncOverwrite(unittest.TestCase):
    def test_sync_overwrites_outdated_file(self):
        with tempfile.TemporaryDirectory(prefix="sync_overwrite_") as root:
            peer_a = os.path.join(root, "peerA")
            peer_b = os.path.join(root, "peerB")
            os.makedirs(peer_a)
            os.makedirs(peer_b)

            filename = "shared.txt"
            a_file = os.path.join(peer_a, filename)
            b_file = os.path.join(peer_b, filename)

            with open(a_file, "w", encoding="utf-8") as f:
                f.write("new version from peer A")
            with open(b_file, "w", encoding="utf-8") as f:
                f.write("old version")

            old_mtime = int(time.time()) - 120
            new_mtime = old_mtime + 60
            os.utime(a_file, (new_mtime, new_mtime))
            os.utime(b_file, (old_mtime, old_mtime))

            file_peer_server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            file_peer_server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
            file_peer_server.bind(("127.0.0.1", 0))
            file_peer_port = file_peer_server.getsockname()[1]
            file_peer_server.listen(1)

            def file_peer_run():
                try:
                    conn, _ = file_peer_server.accept()
                    with conn:
                        requested = Buffer(conn, 8192).get_line()
                        if requested == filename:
                            with open(a_file, "rb") as f:
                                data = f.read()
                            conn.sendall(
                                f"Content-Length: {len(data)}\n".encode("utf-8")
                            )
                            time.sleep(0.05)
                            conn.sendall(data)
                finally:
                    file_peer_server.close()

            file_peer_thread = threading.Thread(target=file_peer_run, daemon=True)
            file_peer_thread.start()

            tracker_payload = {
                filename: {
                    "ip": "127.0.0.1",
                    "port": file_peer_port,
                    "mtime": new_mtime,
                }
            }

            tracker_server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            tracker_server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
            tracker_server.bind(("127.0.0.1", 0))
            tracker_port = tracker_server.getsockname()[1]
            tracker_server.listen(1)

            def tracker_run():
                try:
                    conn, _ = tracker_server.accept()
                    with conn:
                        _ = Buffer(conn, 8192).get_line()
                        conn.sendall(
                            (json.dumps(tracker_payload) + "\n").encode("utf-8")
                        )
                finally:
                    tracker_server.close()

            tracker_thread = threading.Thread(target=tracker_run, daemon=True)
            tracker_thread.start()

            fs = None
            original_cwd = os.getcwd()
            try:
                os.chdir(peer_b)
                fs = FileSynchronizer("127.0.0.1", tracker_port, 0, "127.0.0.1")
                fs.client.connect(("127.0.0.1", tracker_port))
                with patch("fileSynchronizer.threading.Timer", NoOpTimer):
                    fs.sync()
            finally:
                os.chdir(original_cwd)
                if fs is not None:
                    fs.server.close()
                    fs.client.close()
                file_peer_thread.join(timeout=2)
                tracker_thread.join(timeout=2)

            with open(b_file, "r", encoding="utf-8") as f:
                self.assertEqual(f.read(), "new version from peer A")
            self.assertEqual(int(os.path.getmtime(b_file)), new_mtime)


if __name__ == "__main__":
    unittest.main(verbosity=2)

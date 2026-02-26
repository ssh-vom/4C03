import os
import socket
import tempfile
import threading
import time
import unittest

from fileSynchronizer import FileSynchronizer


class TestFailurePeerDisconnect(unittest.TestCase):
    def test_syncfile_handles_mid_transfer_disconnect(self):
        with tempfile.TemporaryDirectory(prefix="failure_peer_disconnect_") as test_dir:
            original_cwd = os.getcwd()
            os.chdir(test_dir)

            fs = FileSynchronizer("127.0.0.1", 9999, 0, "127.0.0.1")

            peer_server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            peer_server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
            peer_server.bind(("127.0.0.1", 0))
            peer_port = peer_server.getsockname()[1]
            peer_server.listen(1)

            filename = "broken.txt"
            advertised_size = 20
            partial_data = b"short"
            mtime = int(time.time())

            def peer_run():
                try:
                    conn, _ = peer_server.accept()
                    with conn:
                        _ = conn.recv(1024)
                        conn.sendall(
                            f"Content-Length: {advertised_size}\n".encode("utf-8")
                        )
                        time.sleep(0.05)
                        conn.sendall(partial_data)
                finally:
                    peer_server.close()

            peer_thread = threading.Thread(target=peer_run, daemon=True)
            peer_thread.start()

            try:
                fs.syncfile(
                    filename,
                    {"ip": "127.0.0.1", "port": peer_port, "mtime": mtime},
                )
            finally:
                fs.server.close()
                fs.client.close()
                peer_thread.join(timeout=2)
                os.chdir(original_cwd)

            self.assertFalse(os.path.exists(filename))
            self.assertFalse(os.path.exists(filename + ".part"))


if __name__ == "__main__":
    unittest.main(verbosity=2)

import socket
import threading
import time
import unittest
from unittest.mock import patch

from fileSynchronizer import FileSynchronizer


class TestFailureTrackerTimeout(unittest.TestCase):
    def test_sync_tracker_timeout_triggers_failure_handler(self):
        tracker_server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        tracker_server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        tracker_server.bind(("127.0.0.1", 0))
        tracker_port = tracker_server.getsockname()[1]
        tracker_server.listen(1)

        def tracker_run():
            try:
                conn, _ = tracker_server.accept()
                with conn:
                    _ = conn.recv(8192)
                    time.sleep(1)
            finally:
                tracker_server.close()

        tracker_thread = threading.Thread(target=tracker_run, daemon=True)
        tracker_thread.start()

        fs = FileSynchronizer("127.0.0.1", tracker_port, 0, "127.0.0.1")
        fs.client.settimeout(0.2)

        try:
            fs.client.connect(("127.0.0.1", tracker_port))

            with patch.object(
                fs,
                "fatal_tracker",
                side_effect=RuntimeError("fatal_tracker_called"),
            ) as fatal:
                with self.assertRaises(RuntimeError):
                    fs.sync()

                self.assertTrue(fatal.called)
                self.assertIn(
                    "Failed waiting for the tracker to response",
                    fatal.call_args[0][0],
                )
        finally:
            fs.server.close()
            fs.client.close()
            tracker_thread.join(timeout=2)


if __name__ == "__main__":
    unittest.main(verbosity=2)

import os
import socket
import threading
import shutil
import tempfile
import unittest

from fileSynchronizer import Buffer, FileSynchronizer


class TestProcessMessage(unittest.TestCase):
    def test_serving_files_via_socket(self):
        test_dir = tempfile.mkdtemp()
        test_file = os.path.join(test_dir, "test.txt")
        test_content = "Hello World"
        with open(test_file, "w") as f:
            f.write(test_content)

        original_dir = os.getcwd()
        os.chdir(test_dir)

        try:
            fs = FileSynchronizer("127.0.0.1", 9999, 19999, "127.0.0.1")
            fs.server.settimeout(3)

            def serve():
                conn, addr = fs.server.accept()
                fs.process_message(conn, addr)

            thread = threading.Thread(target=serve)
            thread.start()

            client = socket.socket()
            client.connect(("127.0.0.1", 19999))
            client.send(b"test.txt\n")

            buff = Buffer(client, 8192)
            header = buff.get_line()

            self.assertTrue(header.startswith("Content-Length: "))
            size = int(header.split(": ")[1])
            self.assertEqual(size, len(test_content))

            remaining = buff.buffer
            data = remaining
            while len(data) < size:
                chunk = client.recv(8192)
                if not chunk:
                    break
                data += chunk

            self.assertEqual(data.decode(), test_content)

            client.close()
            thread.join(timeout=1)

        finally:
            os.chdir(original_dir)
            shutil.rmtree(test_dir)


if __name__ == "__main__":
    unittest.main(verbosity=2)

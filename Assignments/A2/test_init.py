import unittest
from fileSynchronizer import FileSynchronizer, get_next_avaliable_port
from tracker import Tracker
import time


# server socket is bound to the correct port
class testinitfilesynchronizer(unittest.TestCase):
    def test_init_file_synchronizer(self):
        tracker_host = "0.0.0.0"
        tracker_port = 8000
        tr = Tracker(tracker_port, tracker_host)
        synchronizer_port = get_next_avaliable_port(8000)
        tr.start()
        fs = FileSynchronizer(
            trackerhost=tracker_host,
            trackerport=tracker_port,
            port=synchronizer_port,
        )
        fs.start()
        time.sleep(0.5)
        sock_name = fs.server.getsockname()
        assert sock_name[1] == synchronizer_port
        # ensures that server is listening
        assert fs.server.fileno() != -1
        # check that client is properly connected

        assert fs.port == synchronizer_port
        assert fs.host == tracker_host
        assert fs.BUFFER_SIZE == 8192
        assert fs.client.timeout == 180
        expected_msg = b'{"port": 8001, "files": []}\n'
        assert fs.msg == expected_msg

        peer_name = fs.client.getpeername()
        assert peer_name[0] == "127.0.0.1"
        assert peer_name[1] == tracker_port

        fs.exit()


if __name__ == "__main__":
    unittest.main()

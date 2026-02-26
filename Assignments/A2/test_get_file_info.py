import os.path
import unittest
from fileSynchronizer import get_file_info


class TestGetFileInfo(unittest.TestCase):
    def test_get_file_info(self):
        res = get_file_info()
        expected = []
        self.assertEqual(res, expected)

    def test_get_file_info_with_test_file(self):
        # Create test.txt
        with open("test.txt", "w") as f:
            f.write("test")

        try:
            res = get_file_info()
            # Check if test.txt is found properly
            failed = True
            for entry in res:
                if entry["name"] == "test.txt":
                    failed = False
                    break
            assert not failed
        finally:
            # Clean up: remove test.txt
            if os.path.exists("test.txt"):
                os.remove("test.txt")


if __name__ == "__main__":
    unittest.main()

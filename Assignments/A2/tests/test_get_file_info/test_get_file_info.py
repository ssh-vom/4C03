import os.path
import json
import unittest


def get_files_dic():
    """Get file info as a dictionary {name: mtime} in local directory.
    Hint: same filtering rules as get_file_info().
    """
    EXCLUDED_FILETYPES = [".py", ".dll", ".so"]
    files = [
        f
        for f in os.listdir(".")
        if os.path.isfile(os.path.join(".", f))
        and not any(f.lower().endswith(e) for e in EXCLUDED_FILETYPES)
    ]
    file_dic = {f: round(os.path.getmtime(f)) for f in files}

    return file_dic


def get_file_info():
    """Get file info in the local directory (subdirectories are ignored).
    Return: a JSON array of {'name':file,'mtime':mtime}
    i.e, [{'name':file,'mtime':mtime},{'name':file,'mtime':mtime},...]
    Hint: a. you can ignore subfolders, *.so, *.py, *.dll, and this script
          b. use os.path.getmtime to get mtime, and round down to integer
    """
    """
    mtime: is file's last modified time, rounded down to an integer (seconds since epoch)
    files: list of files in peer's working directory
    this is used for init message:
    
    """
    return json.dumps(get_files_dic())
    # YOUR CODE


class TestGetFileInfo(unittest.TestCase):
    def test_get_file_info(self):
        res = get_file_info()
        expected = "{}"
        self.assertEqual(res, expected)

    def test_get_file_info_with_test_file(self):
        # Create test.txt
        with open("test.txt", "w") as f:
            f.write("test")

        try:
            res = get_file_info()
            # Check if test.txt is found properly
            self.assertIn("test.txt", res)
        finally:
            # Clean up: remove test.txt
            if os.path.exists("test.txt"):
                os.remove("test.txt")


if __name__ == "__main__":
    unittest.main()

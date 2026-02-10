import os
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


class TestGetFileInfo(unittest.TestCase):
    def test_get_files_dics(self):
        res = get_files_dic()
        print(res)


if __name__ == "__main__":
    unittest.main()

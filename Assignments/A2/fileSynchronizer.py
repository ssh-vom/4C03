#!/usr/bin/python3
# ==============================================================================
# description     :This is a skeleton code for programming assignment
# usage           :python Skeleton.py trackerIP trackerPort
# python_version  :>= 3.5
# Authors         :Yongyong Wei, Rong Zheng
# ==============================================================================

import socket
import sys
import threading
import json
import os
import os.path
import optparse

MAX_PORT = 2**16


class Buffer:
    def __init__(self, sock, buffer_size):
        self.sock = sock
        self.buffer = b""
        self.delimiter = b"\n"
        self.buffer_size = buffer_size

    def get_line(self):
        while self.delimiter not in self.buffer:
            data = self.sock.recv(self.buffer_size)  # read a byte
            if not data:
                return None
            self.buffer += data
        line, sep, self.buffer = self.buffer.partition(self.delimiter)
        return line.decode()


def validate_ip(s):
    """
    Validate the IP address of the correct format
    Arguments:
    s -- dot decimal IP address in string
    Returns:
    True if valid; False otherwise
    """
    a = s.split(".")
    if len(a) != 4:
        return False
    for x in a:
        if not x.isdigit():
            return False
        i = int(x)
        if i < 0 or i > 255:
            return False
    return True


def validate_port(x):
    """Validate the port number is in range [0,2^16 -1 ]
    Arguments:
    x -- port number
    Returns:
    True if valid; False, otherwise
    """
    if not x.isdigit():
        return False
    i = int(x)
    if i < 0 or i > 65535:
        return False
    return True


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
    
    {
        "port": <int>,
        "files": get_file_info()
    }
    """

    file_arr = [
        {"name": name, "mtime": mtime} for name, mtime in get_files_dic().items()
    ]

    return file_arr


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
    file_dic = {f: int(os.path.getmtime(f)) for f in files}

    return file_dic


def check_port_avaliable(check_port):
    """Check if a port is available
    Arguments:
    check_port -- port number
    Returns:
    True if valid; False otherwise
    """
    if str(check_port) in os.popen("netstat -na").read():
        return False
    return True


def get_next_avaliable_port(initial_port: int):
    """Get the next available port by searching from initial_port to 2^16 - 1
       Hint: You can call the check_port_avaliable() function
             Return the port if found an available port
             Otherwise consider next port number
    Arguments:
    initial_port -- the first port to check

    Return:
    port found to be available; False if no port is available.
    """

    for port_num in range(initial_port, MAX_PORT):
        if check_port_avaliable(port_num):
            return port_num

    return False


class FileSynchronizer(threading.Thread):
    def __init__(self, trackerhost, trackerport, port, host="0.0.0.0"):

        threading.Thread.__init__(self)

        # Own port and IP address for serving file requests to other peers
        self.port = port
        self.host = host

        # Tracker IP/hostname and port
        self.trackerhost = trackerhost
        self.trackerport = trackerport

        self.BUFFER_SIZE = 8192

        # Create a TCP socket to communicate with the tracker
        self.client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.client.settimeout(180)
        self._tracker_buf = Buffer(self.client, self.BUFFER_SIZE)
        self.msg = (
            json.dumps({"port": self.port, "files": get_file_info()}) + "\n"
        ).encode("utf-8")

        # Create a TCP socket to serve file requests from peers.
        self.server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

        try:
            self.server.bind((self.host, self.port))
        except socket.error:
            print(("Bind failed %s" % (socket.error)))
            sys.exit()
        self.server.listen(10)

    def fatal_tracker(self, message, exc=None):
        """Abort the process on tracker failure"""
        if exc is not None:
            print((message, exc))
        else:
            print(message)
        try:
            self.server.close()
        except Exception:
            pass
        os._exit(1)

    # Not currently used. Ensure sockets are closed on disconnect
    def exit(self):
        self.server.close()
        self.client.close()

    # Handle file request from a peer(i.e., send the file content to peers)
    def process_message(self, conn, addr):
        """
        Arguments:
        self -- self object
        conn -- socket object for an accepted connection from a peer
        addr -- IP address of the peer (only used for testing purpose)
        """
        filename = ""
        with conn:  # automates enter and exit
            # Step 1. read the file name terminated by '\n'
            conn.settimeout(30)  #  set time out on the socket
            print(f"Connected to {addr}")
            buff = Buffer(conn, self.BUFFER_SIZE)
            try:
                filename = buff.get_line()
            except socket.timeout:
                print(f"Timeout waiting for file from {addr}")
                return

            if filename:
                # Step 2. read content of that file in binary mode
                with open(file=filename, mode="rb") as f:
                    data = f.read()
                    # Step 3. send header "Content-Length: <size>\n" then file bytes
                    conn.send(f"Content-Length: {len(data)}\n".encode("utf-8"))
                    conn.send(data)
        print(f"Disconnected from {addr}")

        # Step 4. close conn when you are done.
        # This happens on __exit__ from our context manager 'with conn' statement

    def run(self):
        # Step 1. connect to tracker; on failure, may terminate
        try:
            self.client.connect((self.trackerhost, self.trackerport))
        except socket.error as e:
            self.fatal_tracker("Terminating on failed connection to tracker", e)
        t = threading.Timer(2, self.sync)
        t.start()
        print(("Waiting for connections on port %s" % (self.port)))
        while True:
            # Hint: guard accept() with try/except and exit cleanly on failure
            try:
                conn, addr = self.server.accept()
                threading.Thread(target=self.process_message, args=(conn, addr)).start()
            except socket.error as e:
                print(f"Failed to accept connection {e}")
                self.exit()  # on fail we close server and client connection
                break

    def sync(self):
        # Send Init or KeepAlive message to tracker, handle directory response message
        # and  request files from peers
        print(("connect to:" + self.trackerhost, self.trackerport))

        # Step 1. send Init msg to tracker (Note init msg only sent once)
        # Since self.msg is already initialized in __init__, you can send directly
        # Hint: on send failure, may terminate
        try:
            self.client.send(self.msg)
        except socket.error as e:
            self.fatal_tracker("Failed to send init message", e)
        # Step 2. now receive a directory response message from tracker
        # Hint: read from socket until you receive a full JSON message ending with '\n'
        try:
            directory_response_message = self._tracker_buf.get_line()
        except socket.timeout as e:
            self.fatal_tracker("Failed waiting for the tracker to response", e)

        if directory_response_message is None:
            self.fatal_tracker("No directory response, tracker connection is closed")

        print("received from tracker:", directory_response_message)
        try:
            tracker_files = json.loads(directory_response_message)
        except json.JSONDecodeError as e:
            self.fatal_tracker("Invalid JSON from tracker", e)
        local_files = get_files_dic()

        for filename, file_info in tracker_files.items():
            if filename not in local_files:
                # we need to download it
                print(f"New file found: {filename}")
                self.syncfile(filename, file_info)

            elif file_info["mtime"] > local_files[filename]:
                print(f"New version of file {filename} discovered")
                self.syncfile(filename, file_info)

        # Step 4. construct a KeepAlive message
        # Note KeepAlive msg is sent multiple times, the format can be found in Table 1
        # use json.dumps to convert python dict to json string.
        self.msg = (json.dumps({"port": self.port}) + "\n").encode(
            "utf-8"
        )  # Keep alive message

        # Step 5. start timer
        t = threading.Timer(5, self.sync)
        t.start()

    def syncfile(self, filename, file_dic):
        """Fetch a file from a peer and store it locally.

        Arguments:
        filename -- file name to request
        file_dic -- dict with 'ip', 'port', and 'mtime'
        """

        peer = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        peer.settimeout(10)  # timeout on connection
        try:
            # Step 1. connect to peer and send filename + '\n'
            peer.connect((file_dic["ip"], file_dic["port"]))
            peer.send((filename + "\n").encode("utf-8"))

            buff = Buffer(peer, self.BUFFER_SIZE)
            header = buff.get_line()
            # Step 2. read header "Content-Length: <size>\n"
            if header:
                # Remove the prefix for content length to grab the <size>
                _, size = header.split("Content-Length: ")
                try:
                    size = int(size)
                except (ValueError, TypeError) as e:
                    print(f"Invalid Content-Length header {e}")
                    return
                if size:
                    # Step 3. read exactly <size> bytes; if short, discard partial file
                    data = b""
                    while len(data) < size:
                        chunk = peer.recv(min(self.BUFFER_SIZE, size - len(data)))
                        if not chunk:
                            break
                        data += chunk
                    if len(data) == size:
                        partial_file = filename + ".part"
                        # Step 4. write file to disk (binary), rename from .part when done
                        try:
                            with open(partial_file, mode="wb") as f:
                                f.write(data)
                            os.rename(partial_file, filename)
                            # Step 5. set mtime using os.utime
                            os.utime(filename, (file_dic["mtime"], file_dic["mtime"]))
                            print(f"Successfully downloaded {filename}")
                        except Exception as e:
                            # clean up part file if it exists?
                            if os.path.exists(partial_file):
                                os.remove(partial_file)
                            print(f"Failed to write due to {e}")
        except (socket.timeout, socket.error) as e:
            print(f"Timeout connecting to peer for {filename}: {e}")
        peer.close()


if __name__ == "__main__":
    parser = optparse.OptionParser(usage="%prog ServerIP ServerPort")
    try:
        options, args = parser.parse_args()
    except SystemExit:
        sys.exit(1)

    if len(args) < 1:
        parser.error("No ServerIP and ServerPort")
    elif len(args) < 2:
        parser.error("No  ServerIP or ServerPort")
    else:
        if validate_ip(args[0]) and validate_port(args[1]):
            tracker_ip = args[0]
            tracker_port = int(args[1])

            # get a free port
            synchronizer_port = get_next_avaliable_port(8000)
            synchronizer_thread = FileSynchronizer(
                tracker_ip, tracker_port, synchronizer_port
            )
            synchronizer_thread.start()
        else:
            parser.error("Invalid ServerIP or ServerPort")

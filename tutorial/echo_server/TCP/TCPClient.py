from socket import *


def client():
    host = ""
    serverPort = 12000
    clientSocket = socket(AF_INET, SOCK_STREAM)
    clientSocket.connect((host, serverPort))

    while 1:
        message = input("Input lowercase sentence:")
        clientSocket.send(bytes(message, "utf-8"))

        modifiedMessage = clientSocket.recv(2048)
        print("From Server: " + modifiedMessage.decode("utf-8"))

        if KeyboardInterrupt:
            clientSocket.close()


client()

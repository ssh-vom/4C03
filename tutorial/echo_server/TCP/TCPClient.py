from socket import *

host = ""
serverPort = 12000
clientSocket = socket(AF_INET, SOCK_STREAM)
clientSocket.connect((host, serverPort))


message = input("Input lowercase sentence:")
clientSocket.send(bytes(message, "utf-8"))


modifiedMessage = clientSocket.recv(2048)
print("From Server: " + modifiedMessage.decode("utf-8"))
clientSocket.close()

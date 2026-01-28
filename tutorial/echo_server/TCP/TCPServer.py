from socket import *

serverPort = 12000
serverSocket = socket(AF_INET, SOCK_STREAM)
serverSocket.bind(("", serverPort))
serverSocket.listen(1)
print("The server is ready to receive")
while 1:
    connectionSocket, addr = serverSocket.accept()
    print(addr)
    sentence = connectionSocket.recv(1024).decode("utf-8")
    capitalizedSentence = sentence.upper()
    connectionSocket.send(bytes(capitalizedSentence, "utf-8"))
    connectionSocket.close()

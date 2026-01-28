from socket import *

host = '127.0.0.1'
#host = "localhost"
#host = ""
#host = gethostbyname(gethostname())
serverPort = 12000
clientSocket = socket(AF_INET, SOCK_DGRAM) 
message = input("Input lowercase sentence:") 
clientSocket.sendto(bytes(message, 'utf-8'),(host, serverPort)) 
modifiedMessage, serverAddress = clientSocket.recvfrom(2048) 
print(modifiedMessage.decode("utf-8"))
clientSocket.close()

from socket import *
host = '127.0.0.1'
#host = "localhost"
#host = gethostbyname(gethostname())
serverPort = 12000
clientSocket = socket(AF_INET, SOCK_DGRAM) 
clientSocket.settimeout(2.0)

message = input('Input lowercase sentence:') 

try:
	clientSocket.sendto(bytes(message, 'utf-8'),(host, serverPort)) 
	modifiedMessage, serverAddress = clientSocket.recvfrom(2048) 
	print(modifiedMessage.decode("utf-8"))
except timeout:
	print("No response — server likely down")

clientSocket.close()

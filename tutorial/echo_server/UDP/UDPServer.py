from socket import AF_INET, SOCK_DGRAM, socket
serverPort = 12000
serverSocket = socket(AF_INET, SOCK_DGRAM) 
serverSocket.bind(("", serverPort))
print ('The server is ready to receive')
while 1:
	message, clientAddress = serverSocket.recvfrom(2048) 
	decodedMessage = message.decode("utf-8")

	print(f"Received '{decodedMessage}' from {clientAddress}")

	modifiedMessage = decodedMessage.upper() 
	serverSocket.sendto(bytes(modifiedMessage,'utf-8'), clientAddress)

import net

# Set constants
const
    target_host = "172.26.200.210"
    target_port = 9999

# Creates a UDP connection. Need to specify Domain, SockType, Protocol
var client = newSocket(AF_INET, SOCK_DGRAM, IPPROTO_UDP)

# Must pass a Port object to connect
client.connect(target_host, Port(target_port))

# Send some data
client.send("Hello")

# Receive some data
var response = client.recv(4096)

echo response
client.close()

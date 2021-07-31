import net

# Set constants
const
    target_host = "127.0.0.1"
    target_port = 9999

# Creates a TCP connection by default
var client = newSocket()

# Must pass a Port object to connect
client.connect(target_host, Port(target_port))

# Send some data
# For connection to Nim servers, needs to end with "\c\l"
# https://forum.nim-lang.org/t/1168
client.send("Hello\c\L")

# Receive some data
var response = client.recvLine()

echo response
client.close()

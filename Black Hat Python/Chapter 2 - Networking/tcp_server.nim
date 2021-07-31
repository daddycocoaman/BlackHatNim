import net
import strformat

# Set constants
const
    server_host = "0.0.0.0"
    server_port = 9999

# Function to handle client requests
proc handle_client(client: Socket) {.thread.} =
    try:
        var request = client.recvLine()
        echo fmt"[*] Received: {request}"
        client.send("ACK")
    finally:
        client.close()

# Creates a TCP connection by default
var server = newSocket()

# Opposite order of Python. Port then addr
server.bindAddr(Port(server_port), server_host)
server.listen(5)
echo fmt"Listening on {server_host}:{server_port}"

# acceptAddr takes a Socket and string and will "out" the values
var client: Socket
while true:
    server.accept(client)
    let (remote_addr, remote_port) = client.getPeerAddr()
    echo fmt"[*] Accepted connection from {remote_addr}:{remote_port}"

    # Creates a thread and waits for it to end
    var thread: Thread[Socket]
    createThread(thread, handle_client, client)
    joinThread(thread)

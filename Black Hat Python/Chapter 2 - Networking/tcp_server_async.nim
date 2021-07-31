import asyncnet, asyncdispatch
import strformat

# Set constants
const
    server_host = "0.0.0.0"
    server_port = 9999

var clients {.threadvar.}: seq[AsyncSocket]

proc handle_client(client: AsyncSocket) {.async.} =
    while true:
        let request = await client.recvLine()
        if request != "":
            echo fmt"[*] Received: {request}"
            await client.send("ACK" & "\c\L")
        else:
            client.close()
            break

proc serve() {.async.} =
    # Keeps track of clients
    clients = @[]

    # Creates a TCP connection by default
    var server = newAsyncSocket()
    server.setSockOpt(OptReuseAddr, true)

    # Opposite order of Python. Port then addr
    server.bindAddr(Port(server_port), server_host)
    server.listen()
    echo fmt"Listening on {server_host}"

    # acceptAddr takes a Socket and string and will "out" the values
    while true:
        let client = await server.accept()
        var (remote_addr, remote_port) = client.getPeerAddr()
        echo fmt"[*] Accepted connection from {remote_addr}:{uint16(remote_port)}"

        # Creates a thread and waits for it to end
        asyncCheck handle_client(client)

asyncCheck serve()
runForever()

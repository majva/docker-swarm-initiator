
from socket import socket, AF_INET, SOCK_STREAM, SOL_SOCKET, SO_REUSEADDR, SHUT_RDWR


def main():
    try:
        soc = socket(AF_INET, SOCK_STREAM)
        soc.setsockopt(SOL_SOCKET, SO_REUSEADDR,  1)
        soc.connect(('127.0.0.1', 9000))

        while True:
            message: str = input("Enter your message: ")
            soc.sendall(message.encode("utf8"))
            print(f"message send successfully to server as {message}")
            incoming_message: str = str(soc.recv(8096).decode("utf8"))
            print(f"message received from server as {incoming_message}")
            if message == "EXIT":
                soc.close()
                break

    except KeyboardInterrupt:
        soc.close()


if __name__ == "__main__":
    main()

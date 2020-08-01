
from socket import socket, AF_INET, SOCK_STREAM, SOL_SOCKET, SO_REUSEADDR, SHUT_RDWR
from threading import Thread
from os.path import exists as dir_exist
from os import mkdir
from datetime import datetime

from environs import Env


class ClientHandler(Thread):
    def __init__(self, client_socket_obj: socket, client_address: tuple):
        Thread.__init__(self)

        self.client_socket = client_socket_obj
        self.client_address = client_address
        self.app_log_path = './logs'
        self.app_log_file = '/app.log'


    def run(self):
        with open(self.app_log_path + self.app_log_file, 'a') as file:
            while True:
                message: str = str(self.client_socket.recv(8096).decode('utf8'))
                time: str = str(datetime.now()).split('.')[0]
                file.write(
                    f"{time} => [+] client sent message to server as [{message}] ..."
                )
                self.client_socket.sendall(f"Message received to server successfully at {time}".encode("utf8"))
                if message == "EXIT":
                    self.client_socket.close()
                    break

def main():
    app_log_path = './logs'
    app_log_file = '/app.log'

    if not dir_exist(app_log_path):
        mkdir(app_log_path)

    env_file = Env()
    env_file.read_env()

    soc = socket(AF_INET, SOCK_STREAM)
    soc.setsockopt(SOL_SOCKET, SO_REUSEADDR,  1)
    soc.bind((env_file("SERVER_HOST"), env_file.int("SERVER_PORT")))
    soc.listen(env_file.int("SERVER_MAX_CLIENT_CONNECTION"))
    print(f"Server start successfully on port {env_file.int('SERVER_PORT')}")
    with open(app_log_path + app_log_file, 'a') as file:
        time: str = str(datetime.now()).split('.')[0]
        file.write(f"{time} => [+] socket binded successfully ...")
        try:
            while True:
                client_socket_obj, client_address = soc.accept()
                time: str = str(datetime.now()).split('.')[0]
                file.write(
                    f"{time} => [+] client joined to server as [{client_address}] ..."
                )
                ClientHandler(
                    client_socket_obj=client_socket_obj, 
                    client_address=client_address
                ).start()
        except KeyboardInterrupt:
            soc.close()
            soc.shutdown(SHUT_RDWR)
            time: str = str(datetime.now()).split('.')[0]
            file.write(
                f"{time} => [+] client joined to server as [{client_address}] ..."
            )
            del soc, time


if __name__ == "__main__":
    main()

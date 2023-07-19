import re

from sys import argv

fname = argv[1]

# X is A|M
decode_comp = {
    "0":   "101010",
    "1":   "111111",
    "-1":  "111010",
    "D":   "001100",
    "X":   "110000",
    "!D":  "001101",
    "!X":  "110001",
    "-D":  "001111",
    "-X":  "110011",
    "D+1": "011111",
    "X+1": "110111",
    "D-1": "001110",
    "X-1": "110010",
    "D+X": "000010",
    "D-X": "010011",
    "X-D": "000111",
    "D&X": "000000",
    "D|X": "010101"
}

decode_jump = {
    ""   : "000",
    "JGT": "001",
    "JEQ": "010",
    "JGE": "011",
    "JLT": "100",
    "JNE": "101",
    "JLE": "110",
    "JMP": "111"
}

symbol_table = {
    "R0":  0,
    "R1":  1,
    "R2":  2,
    "R3":  3,
    "R4":  4,
    "R5":  5,
    "R6":  6,
    "R7":  7,
    "R8":  8,
    "R9":  9,
    "R10": 10,
    "R11": 11,
    "R12": 12,
    "R13": 13,
    "R14": 14,
    "R15": 15,
    "SCREEN": 16384,
    "KBD":    24576,
    "SP":   0,
    "LCL":  1,
    "ARG":  2,
    "THIS": 3,
    "THAT": 4,
}

N = 16 # 16 bits, used for padding

code = []
with open(fname, "r") as f:
    code = f.readlines()

code = [line.strip() for line in code] # strip \n etc
code = [line for line in code if len(line) > 0 and line[:2] != "//"] # drop empty lines and comment lines

# enter labels into symbol table
line_number = 0
for line in code:
    # L-ins
    if line[0] == "(": 
        label = line[1:-1] # label name
        symbol_table[label] = line_number #
     # not a L-ins, increment line number
    else:
        line_number += 1

 # we can now drop labels, since they are added into the symbol table
code = [line for line in code if line[0] != "("]

# enter variables into symbol table
var_idx = 16 # start of address for new variables
for line in code:
    c = line[0]
    var = line[1:]

    # we want a new variable
    # so a-ins, but not @num and not predefined
    if c == "@" and not var.isnumeric() and var not in symbol_table:
        # it's a new variable
        symbol_table[var] = var_idx
        var_idx += 1

# replace variables with their corresponding entry in the symbol table
# this includes new variables as well as predefined ones

for idx, line in enumerate(code):
    c = line[0]
    var = line[1:]
    # it's a variable
    if c == "@" and not var.isnumeric():
         # lookup the variable and replace it with it's value in symbol table
        code[idx] = line.replace(var, str(symbol_table[var]))

for idx, line in enumerate(code):
    c = line[0]
    # a-ins
    if c == "@":
        num = int(line[1:])
        # convert to binary and left-pad with 0, to 16 bits.
        code[idx] = f"{num:>0{N}b}"
    # c-ins
    else:
        # split into dest, comp, jump
        parsed_line = re.split('=|;', line)
        if "=" not in line: parsed_line.insert(0, "")
        if ";" not in line: parsed_line.append("")
        dest, comp, jump = parsed_line

        # decode dest
        a = '1' if "A" in dest else '0'
        d = '1' if "D" in dest else '0'
        m = '1' if "M" in dest else '0'
        dest = a+d+m

        # decode comp
        a_bit = "1" if "M" in comp else "0"
        comp = re.sub('A|M', 'X', comp)
        comp = decode_comp[comp]
        comp = a_bit + comp


        # decode jump
        jump = decode_jump[jump]

        code[idx] = "111" + comp + dest + jump

# from binary "1101" to integer
code = [int(line, 2) for line in code]

# from integer to hex
code = [f"{line:>04X}" for line in code]

fname_woext = fname.split(".")[0]
fname_out = f"{fname_woext}.hex"

print("out: ", fname_out)
with open (fname_out, "w+") as f:
    for line in code:
        f.write(line)
        f.write("\n")

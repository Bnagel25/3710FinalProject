"""
File to hold OPCODE constants
Opcodes are stored in an array of tuples
Register files (sample) are also in an array of tuples
"""

INSTR_OFFSET = 15500

reg_dict = [("%r0", "0000"),
            ("%r1", "0001"),
            ("%r2", "0010"),
            ("%r3", "0011"),
            ("%r4", "0100"),
            ("%r5", "0101"),
            ("%r6", "0110"),
            ("%r7", "0111"),
            ("%r8", "1000"),
            ("%r9", "1001"),
            ("%r10", "1010"),
            ("%r11", "1011"),
            ("%r12", "1100"),
            ("%r13", "1101"),
            ("%r14", "1110"),
            ("%r15", "1111")]

opcodes = [("add", "0000"),
           ("addi", "0001"),
           ("sub", "0010"),
           ("lw", "0011"),
           ("sw", "0100"),
           ("lui", "0101"),
           ("cmp", "0110"),
           ("br", "0111"),
           ("jmp", "1000"),
           ("sll", "1001"),
           ("slr", "1010"),
           ("and", "1011"),
           ("nand", "1100"),
           ("or", "1101"),
           ("not", "1110"),
           ("lli", "1111")]

ALU_opcodes = ["0000",  # add
               "0010",  # sub
               "0110",  # cmp
               "1001",  # sll
               "1010",  # slr
               "1011",  # and
               "1100",  # nand
               "1101",  # or
               "1110"]  # not

IMM_opcodes = ["0001",  # addi
               "0101",  # lui
               "1111"]  # lli

ADDR_opcodes = ["0011",  # lw
                "0100",  # sw
                "0111",  # br
                "1000"]  # jmp

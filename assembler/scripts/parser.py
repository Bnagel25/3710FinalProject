import util


def parse_alu(opcode, ele, out_file):
    """
    Parses assembly instruction of alu type
    Converts to a binary string and writes to out_file
    param: opcode: (str) instruction opcode
    param: ele: (str arr) other elements of instruction
    param: out_file: (file) output file
    """
    source = [i for i, v in enumerate(util.reg_dict)
              if v[0] == ele[1]]
    source = "{0:04b}".format(source[0])
    print("\tSource: {}".format(source))

    if opcode == "0000":  # Check for #(reg) format
        split_dest = ele[2].split('(')
        if len(split_dest) > 1:
            new_ele = ['addi', split_dest[1][:-1], split_dest[0]]

            print("Splitting add Instruction\n")
            print(new_ele)
            print("\tOpcode: {}".format("0001"))

            parse_imm('0001', new_ele, out_file)
            ele[2] = split_dest[1][:-1]

    ele[2] = ele[2].split('\n')[0]  # Trim potential \n
    dest = [i for i, v in enumerate(util.reg_dict)
            if v[0] == ele[2]]
    dest = "{0:04b}".format(dest[0])
    print("\tDest: {}".format(dest))

    offset = "0000"
#    if opcode == "1001" or opcode == "1010":  # sll or slr
#        ele[3] = ele[3].split('\n')[0]
#        offset = "{0:04b}".format(int(ele[3]))
#        print("\tOffset: {}".format(offset))

    str_builder = "{}{}{}{},\n".format(opcode,
                                       source,
                                       dest,
                                       offset)
    print(str_builder)
    out_file.write(str_builder)


def parse_imm(opcode, ele, out_file):
    """
    Parses assembly instruction of imm type
    Converts to a binary string and writes to out_file
    param: opcode: (str) instruction opcode
    param: ele: (str arr) other elements of instruction
    param: out_file: (file) output file
    """
    dest = [i for i, v in enumerate(util.reg_dict)
            if v[0] == ele[1]]

    dest = "{0:04b}".format(dest[0])
    print("\tDest: {}".format(dest))

    ele[2] = ele[2].split('\n')[0]  # Trim potential \n
    imm = "{0:08b}".format(int(ele[2]))
    print("\tImm: {}".format(imm))

    str_builder = "{}{}{},\n".format(opcode,
                                     dest,
                                     imm)
    if(len(str_builder) > 18):
        raise Exception("Immediate value surpasses 8 bits")
    print(str_builder)
    out_file.write(str_builder)


def parse_addr(opcode, ele, out_file, mapped_labels):
    """
    Parses assembly instruction of addr type
    Converts to a binary string and writes to out_file
    param: opcode: (str) instruction opcode
    param: ele: (str arr) other elements of instruction
    param: out_file: (file) output file
    param: mapped_labels: (arr of dict) dictionary with{label, binary_location}
    """
    if opcode == "1000":
        ele[1] = ele[1].split('\n')[0]

        jmp_dest = [i['binary'] for i in mapped_labels
                    if i['label'] == ele[1]]

        if len(jmp_dest) > 1:
            raise Exception("Duplicate Label's {}".format(ele[1]))

        jmp_dest = jmp_dest[0]
        print("\tJump to: {}".format(jmp_dest))

        str_builder = "{}{}{},\n".format(opcode,
                                         "0000",
                                         jmp_dest[:8])
        print("\tJmp8: {}".format(jmp_dest[:8]))
        print("\tJmp16: {}".format(jmp_dest[8:24]))
        print(str_builder)
        out_file.write(str_builder)
        out_file.write("{},\n".format(jmp_dest[8:24]))

    elif opcode == "0111":
        dest = [i for i, v in enumerate(util.reg_dict)
                if v[0] == ele[1]]
        ele[2] = ele[2].split('\n')[0]
        jmp_dest = [i['binary'] for i in mapped_labels
                    if i['label'] == ele[2]]
        jmp_dest = jmp_dest[0]
        print("\tJump to: {}".format(jmp_dest))

        str_builder = "{}{}{},\n".format(opcode,
                                         "0000",
                                         jmp_dest[:8])
        print("\tJmp8: {}".format(jmp_dest[:8]))
        print("\tJmp16: {}".format(jmp_dest[8:24]))
        print(str_builder)
        out_file.write(str_builder)
        out_file.write("{},\n".format(jmp_dest[8:24]))

    else:
        dest = [i for i, v in enumerate(util.reg_dict)
                if v[0] == ele[1]]
        dest = "{0:04b}".format(dest[0])
        print("\tDest: {}".format(dest))

        imm = "{0:024b}".format(int(ele[2]))
        print("\tImm: {}".format(imm))

        str_builder = "{}{}{},\n".format(opcode,
                                         dest,
                                         imm[:8])
        print("\tImm8: {}".format(imm[:8]))
        print("\tImm16: {}".format(imm[8:24]))
        out_file.write(str_builder)
        out_file.write("{},\n".format(imm[8:24]))
        print(str_builder)

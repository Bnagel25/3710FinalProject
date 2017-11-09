import argparse
import util
import parser


def first_pass(instruction_file):
    """
    Searches through the instruction file and gathers labels while
    maintaining an internal instruction counter
    param: instruction_file: (file) File where assembly is stored
    ret: dictionary(string, int) of labels to the memory offset
    """
    with open(instruction_file, 'r') as f:
        mapped_labels = []
        count = 0

        for line in f:
            count += 1
            if ":" in line:
                mapped_labels.append({"label": line.split(':')[0],
                                      "binary": "{0:024b}".format(
                                          count + util.INSTR_OFFSET)})

        return mapped_labels


def second_pass(instruction_file, mapped_labels, output_file):
    """
    Takes an instruction file and generates an output coe file
    with the binary translations
    param: instruction_file: (file) File where assembly is stored
    param: mapped_labels: (arr of dict) dictionary with{label, binary_location}
    param: output_file: (str) file path where to output binary file
    """

    with open(instruction_file, 'r') as instr_file:
        with open(output_file, 'w') as out_file:
            line_count = 0
            for line in instr_file:
                if (":" not in line and
                   not line == '\n' and
                   not line.startswith(';') and
                   not line.startswith('/t;')):

                    print("\tLine : {}".format(line_count))

                    line = line.replace(",", "")  # Removes ,
                    ele = line.strip().split(' ')  # Removes tab
                    print(ele)
                    opcode = [i for i, v in enumerate(util.opcodes)
                              if v[0] == ele[0]]
                    opcode = "{0:04b}".format(opcode[0])
                    print("\tOpcode: {}".format(opcode))

                    if opcode in util.ALU_opcodes:
                        parser.parse_alu(opcode, ele, out_file)

                    elif opcode in util.IMM_opcodes:
                        parser.parse_imm(opcode, ele, out_file)

                    elif opcode in util.ADDR_opcodes:
                        parser.parse_addr(opcode, ele, out_file, mapped_labels)

                    else:
                        raise Exception("Opcode not matching known instr")
                line_count += 1


if __name__ == "__main__":
    argparser = argparse.ArgumentParser(description='Assembler for 3710')
    argparser.add_argument('instruction_file', help='instruction file')
    argparser.add_argument('output', help='output coe file',
                           default='output.coe')
    args = argparser.parse_args()
    instruction_file = args.instruction_file
    output_file = args.output

    # Add two lines of memory_initialization
    #  with open(output_file, 'w') as f:
    #    f.write("memory_initialization_radix=2; \n")
    #    f.write("memory_initialization_vector= \n\n")

    mapped_labels = first_pass(instruction_file)
    print(mapped_labels)
    second_pass(instruction_file, mapped_labels, output_file)

    # Add blank instruction at end of file
    # with open(output_file, 'a') as f:
    #     f.write('{};'.format('0'*16))

import argparse

"""
Combines input files to create final output .coe file
Currently mimics our memory structure where
viewable_region offset = 0x0000
glyph           offset = 0x2000
programming     offset = 0x2400
memory mapped   offset = 0x3b00
instructions    offset = 0x3C8C
"""
if __name__ == "__main__":
    argparser = argparse.ArgumentParser(description='Assembler for 3710')
    argparser.add_argument('viewable_region', help='viewable coe file',
                           default='../viewable_out.coe')
    argparser.add_argument('glyphs', help='glyph coe file',
                           default='../RAM-glyph256x4x16.coe')
    argparser.add_argument('instructions', help='Instruction coe file',
                           default='../instructions.coe')
    argparser.add_argument('output', help='output coe file',
                           default='output.coe')
    args = argparser.parse_args()
    viewable_region_file = args.viewable_region
    glyphs_file = args.glyphs
    instruction_file = args.instructions
    output_file = args.output

    with open(output_file, 'w') as out:
        # 8192 for viewable region
        with open(viewable_region_file, 'r') as view:
            for line in view:
                out.write(line)
        # 8192 + 1024 for glyphs
        with open(glyphs_file, 'r') as glyphs:
            for line in glyphs:
                out.write('{}\n'.format(line.rstrip().replace(';', ',')))
        # 9216(0x2400) --> clear 0x3b00 - 0x2400(5888) worth of space
        for i in range(5888):
            out.write('{},\n'.format('0'*16))

        # 0x3b00 to 0x3C8C for memory mapped io
        for i in range(396):
            out.write('{},\n'.format('0'*16))

        # Rest for instructions
        with open(instruction_file, 'r') as instr:
            for line in instr:
                out.write(line)
        out.write('{};\n'.format('0'*16))

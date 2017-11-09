import argparse

"""
Draws static pong image with square char's
"""
if __name__ == "__main__":
    argparser = argparse.ArgumentParser(description='viewable region')
    argparser.add_argument('output_file', help='output coe file')
    args = argparser.parse_args()
    output_file = args.output_file
    with open(output_file, 'w') as f:
        f.write("memory_initialization_radix=2; \n")
        f.write("memory_initialization_vector= \n\n")

        block_ascii = '11011011'  # Square in Ascii
        combined_write = '{}{}'.format('1' * 8, block_ascii)

        draw = [3622, 3623,
                3750, 3751,
                3072, 3073,
                3200, 3201,
                3328, 3329,
                3456, 3457,
                3584, 3585,
                3712, 3713,
                3840, 3841,
                3968, 3969,
                4096, 4097,
                4224, 4225,
                4352, 4353,
                3150, 3151,
                3278, 3279,
                3406, 3407,
                3534, 3535,
                3662, 3663,
                3790, 3791,
                3918, 3919,
                4046, 4047,
                4174, 4175,
                4302, 4303,
                4430, 4431]

        for i in range(8192):
            if i in draw:
                f.write('{},\n'.format(combined_write))
            else:
                f.write('{},\n'.format('0'*16))
        # f.write('{};'.format('0'*16))
        f.close()

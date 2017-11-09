import unittest
import os
import assembler


class TestAssembler(unittest.TestCase):
    """
    Test Cases to test assembler for 3710
    """

    def _delete_file(self, filename):
        os.remove(filename)

    def test_first_pass_no_labels(self):
        input_file = "test_file.txt"
        with open(input_file, 'w') as f:
            f.write('\tadd %r0 %r1 \r\n')
        labels = assembler.first_pass(input_file)
        self.assertEqual(labels, [])
        self._delete_file(input_file)

    def test_first_pass_blank_file(self):
        input_file = "test_file.txt"
        with open(input_file, 'w') as f:
            f.write('')
        labels = assembler.first_pass(input_file)
        self.assertEqual(labels, [])
        self._delete_file(input_file)

    def test_first_pass_label(self):
        input_file = "test_file.txt"
        with open(input_file, 'w') as f:
            f.write('test: \r\n  \tadd %r0 %r1 \r\n')
        labels = assembler.first_pass(input_file)
        self.assertEqual(len(labels),  1)
        self.assertEqual(labels[0]['binary'], '000000000011110010001101')
        self._delete_file(input_file)

    def test_second_pass_blank_file(self):
        input_file = 'test_file.txt'
        with open(input_file, 'w') as f:
            f.write('')
            labels = assembler.first_pass(input_file)
            output_file = 'test_output.coe'
            assembler.second_pass(input_file, labels, output_file)
        with open(output_file, 'r') as f:
            result = f.readline()
            self.assertEqual(result, '{}'.format(''))
        self._delete_file(input_file)
        self._delete_file(output_file)

    def test_second_pass_alu_instruction(self):
        input_file = 'test_file.txt'
        with open(input_file, 'w') as f:
            f.write('\tadd %r0 %r0\r\n')
        labels = assembler.first_pass(input_file)
        output_file = 'test_output.coe'
        assembler.second_pass(input_file, labels, output_file)
        with open(output_file, 'r') as f:
            result = f.readline()
        self.assertEqual(result, '{},\n'.format('0' * 16))

    def test_second_pass_imm_instruction(self):
        input_file = 'test_file.txt'
        with open(input_file, 'w') as f:
            f.write('\taddi %r0 8\r\n')
        labels = assembler.first_pass(input_file)
        output_file = 'test_output.coe'
        assembler.second_pass(input_file, labels, output_file)
        with open(output_file, 'r') as f:
            result = f.readline()
        self.assertEqual(result, '{},\n'.format('0001000000001000'))
        self._delete_file(input_file)
        self._delete_file(output_file)

    def test_second_pass_addr_instructions(self):
        input_file = 'test_file.txt'
        with open(input_file, 'w') as f:
            f.write('test:\r\n\tjmp test\r\n')
        labels = assembler.first_pass(input_file)
        test_label = '000000000011110010001101'
        self.assertEqual(labels[0]['binary'], test_label)
        output_file = 'test_output.coe'
        assembler.second_pass(input_file, labels, output_file)
        with open(output_file, 'r') as f:
            result = f.readlines()
        self.assertEqual(len(result), 2)
        self.assertEqual(len(result[0].strip(',\n')), 16)
        self.assertEqual(len(result[1].strip(',\n')), 16)
        self.assertEqual(result[0],
                         '{},\n'.format('100000000{}'.format(test_label[0:7])))
        self.assertEqual(result[1], '{},\n'.format(test_label[8:24]))
        self._delete_file(input_file)
        self._delete_file(output_file)

    def test_complex_instruction(self):
        input_file = 'test_file.txt'
        with open(input_file, 'w') as f:
            f.write('\tadd %r0 8(%r0)\r\n')
        labels = assembler.first_pass(input_file)
        output_file = 'test_output.coe'
        assembler.second_pass(input_file, labels, output_file)
        with open(output_file, 'r') as f:
            result = f.readlines()
        self.assertEqual(len(result), 2)
        self.assertEqual(len(result[0].strip(',\n')), 16)
        self.assertEqual(len(result[1].strip(',\n')), 16)
        self.assertEqual(result[0], '{},\n'.format('0001000000001000'))
        self.assertEqual(result[1], '{},\n'.format('0000000000000000'))
        self._delete_file(input_file)
        self._delete_file(output_file)


if __name__ == '__main__':
    unittest.main()

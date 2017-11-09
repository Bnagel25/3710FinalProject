import unittest
import os
import assembler as main
# import assembler.scripts.assembler as main
import mock


class TestAssembler(unittest.TestCase):

    def delete_file(self, filename):
        os.rmdir(filename)

    def test_first_pass_no_labels(self):
        filename = "test_file.txt"
        with open(filename, 'w') as f:
            f.write('\t add %r1 %r2 \r\n')
        ret = main.first_pass(filename)
        self.assertEqual(ret, [])
        self.delete_file(filename)

    def test_first_pass_blank_file(self):
        filename = "test_file.txt"
        with open(filename, 'w') as f:
            f.write('')
        ret = main.first_pass(filename)
        self.assertEqual(ret, [])
        self.delete_file(filename)

    def test_first_pass_label(self):
        filename = "test_file.txt"
        with open(filename, 'w') as f:
            f.write('test: \r\n add %r1 %r2 \r\n')
        ret = main.first_pass(filename)
        self.assertEqual(len(ret),  1)
        print(ret)
        self.assertEqual(ret["test:"], 0)
        self.delete_file(filename)


if __name__ == '__main__':
    unittest.main()

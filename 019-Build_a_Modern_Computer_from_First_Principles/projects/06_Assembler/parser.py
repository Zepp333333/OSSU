from translator import Translator
from symbolTable import Symbols


class Parser:
    def __init__(self, raw_input: str):
        self.raw_input = raw_input
        self.symbols = Symbols()
        self.line_input = self.remove_empty_lines()
        self.ast = self.parse()
        self.bin_ast = self.translate()

    def remove_empty_lines(self):
        result = []
        for line in self.raw_input.split('\n'):
            if (not line == '') and (not line[0:2] == '//'):
                result.append(line.split('//')[0].strip())
        return result

    def parse(self):
        # First pass: remove LABEL declarations and store them in Symbols.table
        line_num = 0
        cleaned_input = []
        for line in self.line_input:
            if line[0] == '(':
                self.symbols.add_label(line.strip('()'), line_num)
            else:
                cleaned_input.append(line)
                line_num += 1

        # Second pass: parse and produce list of A ro C Instruction objects
        line_num = 0
        result = []
        for line in cleaned_input:
            if line[0] == '@':
                result.append(AInstruction(line_num, line, self.symbols))
            else:
                result.append(CInstruction(line_num, line))
        return result

    def translate(self):
        return [instruction.translate() for instruction in self.ast]

    def __str__(self):
        return '\n'.join(self.bin_ast)


class Instruction:
    def __init__(self, line_num: int, string: str):
        self.line_num = line_num
        self.string = string


class AInstruction(Instruction):
    def __init__(self, line_num: int, string: str, symbols):
        super().__init__(line_num, string)
        self.symbols = symbols
        self.address = self.parse()

    def parse(self):
        return self.string[1:]

    def translate(self):
        if self.address.isnumeric():
            return Translator.addr(self.address)
        else:
            sym_address = self.symbols.store_and_get_symbol(self.address)
            return Translator.addr(sym_address)


class CInstruction(Instruction):
    def __init__(self, line_num: int, string: str):
        super().__init__(line_num, string)
        self.dest, self.comp, self.jump = self.parse()

    def parse(self):
        if self.string.find('=') >= 0 and self.string.find(';') >= 0:
            left, right = self.string.split('=')
            return left, right.split(';')[0], right.split(';')[1]
        elif self.string.find('=') >= 0:
            left, right = self.string.split('=')
            return left, right, 'null'
        else:
            left, right = self.string.split(';')
            return 'null', left, right

    def translate(self):
        return ''.join(['1', '1', '1',
                        Translator.comp(self.comp),
                        Translator.dest(self.dest),
                        Translator.jump(self.jump)
                        ])

class Symbols:
    pre_defined = {
        'SCREEN': 16384,
        'KBD': 24576,
        'SP': 0,
        'LCL': 1,
        'ARG': 2,
        'THIS': 3,
        'THAT': 4
    }

    def __init__(self):
        self.table = self.prepare_pre_defined()
        self.n = 16

    @staticmethod
    def prepare_pre_defined():
        r_symbols = {"R" + str(i): i for i in range(16)}
        return {**r_symbols, **Symbols.pre_defined}

    def add_label(self, symbol, line_num):
        self.table[symbol] = line_num

    def store_and_get_symbol(self, symbol):
        if not self.lookup(symbol):
            self.table[symbol] = self.n
            self.n += 1
        return str(self.table[symbol])

    def lookup(self, symbol):
        return symbol in self.table.keys()

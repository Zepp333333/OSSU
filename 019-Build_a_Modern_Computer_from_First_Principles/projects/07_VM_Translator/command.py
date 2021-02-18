class Command:
    TYPES = {
        'add':      'C_ARITHMETIC',
        'sub':      'C_ARITHMETIC',
        'neg':      'C_ARITHMETIC',
        'eq':       'C_ARITHMETIC',
        'gt':       'C_ARITHMETIC',
        'lt':       'C_ARITHMETIC',
        'and':      'C_ARITHMETIC',
        'or':       'C_ARITHMETIC',
        'not':      'C_ARITHMETIC',
        'pop':      'C_POP',
        'push':     'C_PUSH',
        'label':    'C_LABEL',
        'goto':     'C_GOTO',
        'if-goto':  'C_IF',
        'function': 'C_FUNCTION',
        'call':     'C_CALL',
        'return':   'C_RETURN'
    }
    TWO_ARG_CMD = ['C_POP', 'C_PUSH', 'C_FUNCTION', 'C_CALL']

    def __init__(self, command: list):
        """
        :param command: list of variable (1-3) length containing strings: vm command, arg1 and arg2
        """
        if command:
            self.command = command[0]
            self.command_type = Command.TYPES[self.command]
            if len(command) == 2:
                self.arg1 = command[1]
                self.arg2 = ''
            elif len(command) == 3:
                self.arg1 = command[1]
                self.arg2 = command[2]
            else:
                self.arg1 = ''
                self.arg2 = ''

    def get_command_type(self) -> str:
        return self.command_type

    def get_command(self) -> str:
        return self.command

    def get_arg1(self) -> str:
            return self.arg1

    def get_arg2(self) -> str:
            return self.arg2



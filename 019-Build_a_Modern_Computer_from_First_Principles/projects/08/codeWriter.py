from command import Command


class CodeWriter:
    ADDRESSES = {
        'local': 'LCL',  # 1
        'argument': 'ARG',  # 2
        'this': 'THIS',  # 3
        'that': 'THAT',  # 4
        'pointer': 3,  # 3-4
        'temp': 5,  # 5-12
        # 13-15 General purpose registers
        'static': 16,  # 16-266
    }

    def __init__(self):
        self.cond_count = 0
        self.current_file = ''
        self.asm = []
        self.call_count = 0
        self.write_init()

    def get_output(self):
        return self.asm

    def set_file_name(self, filename):
        self.current_file = filename

    def write_init(self):
        self.writeln('// Bootstrap code')
        self.writeln('@256')
        self.writeln('D=A')
        self.writeln('@SP')
        self.writeln('M=D')
        self.write_call('Sys.init', 0)

    def write(self, command: Command):
        cmd_type = command.get_command_type()
        cmd = command.get_command()
        arg1 = command.get_arg1()
        arg2 = command.get_arg2()
        self.writeln('// {} {} {}'.format(cmd, arg1, arg2))
        if cmd_type == 'C_ARITHMETIC':
            self.write_arithmetic(cmd)
        elif cmd_type in ['C_PUSH', 'C_POP']:
            self.write_push_pop(cmd, arg1, arg2)
        elif cmd_type == 'C_LABEL':
            self.write_label(arg1)
        elif cmd_type == 'C_GOTO':
            self.write_goto(arg1)
        elif cmd_type == 'C_IF':
            self.write_if(arg1)
        elif cmd_type == 'C_FUNCTION':
            self.write_function(arg1, arg2)
        elif cmd_type == 'C_CALL':
            self.write_call(arg1, arg2)
        elif cmd_type == 'C_RETURN':
            self.write_return()
        else:
            raise Exception("Unknown command type {}".format(cmd))

    def write_label(self, label: str):
        self.writeln('({}${})'.format(self.current_file, label))

    def write_goto(self, label: str):
        self.writeln('@{}${}'.format(self.current_file, label))
        self.writeln('0;JMP')

    def write_if(self, label: str):
        self.stack_to_d()
        self.writeln('@{}${}'.format(self.current_file, label))
        self.writeln('D;JNE')

    def write_function(self, name: str, num_vars: int):
        self.writeln('({})'.format(name))
        for _ in range(int(num_vars)):
            self.writeln('D=0')
            self.d_to_stack()

    def write_call(self, f_name: str, num_args: int):
        ret_addr = f_name + 'RET' + str(self.call_count)
        self.call_count += 1

        # push retAddr
        self.writeln('@' + ret_addr)
        self.writeln('D=A')
        self.d_to_stack()

        # push 'LCL', 'ARG', 'THIS', 'THAT'
        for segment in ['LCL', 'ARG', 'THIS', 'THAT']:
            self.writeln('@' + segment)
            self.writeln('D=M')
            self.d_to_stack()

        # Reposition ARG = SP - 5 -nArgs
        self.writeln('@SP')
        self.writeln('D=M')
        self.writeln('@' + str(int(num_args) + 5))
        self.writeln('D=D-A')
        self.writeln('@ARG')
        self.writeln('M=D')

        # Reposition LCL = SP
        self.writeln('@SP')
        self.writeln('D=M')
        self.writeln('@LCL')
        self.writeln('M=D')

        # goto function name
        self.writeln('@' + f_name)
        self.writeln('0;JMP')

        # retAddr
        self.writeln('({})'.format(ret_addr))

    def write_return(self):
        end_frame = 'R13'
        ret_addr = 'R14'

        # endFrame = LCL
        self.writeln('@LCL')
        self.writeln('D=M')
        self.writeln('@' + end_frame)
        self.writeln('M=D')

        # retAddr = endFrame - 5
        self.writeln('@' + end_frame)
        self.writeln('D=M')
        self.writeln('@5')
        self.writeln('D=D-A')
        self.writeln('A=D')
        self.writeln('D=M')
        self.writeln('@' + ret_addr)
        self.writeln('M=D')

        # *ARG = pop()
        self.stack_to_d()
        self.writeln('@ARG')
        self.writeln('A=M')
        self.writeln('M=D')

        # SP = ARG + 1
        self.writeln('@ARG')
        self.writeln('D=M')
        self.writeln('@SP')
        self.writeln('M=D+1')

        # THAT, THIS, ARG, LCL = endFrame -1, -2, -3, -4
        i = 1
        for segment in ['THAT', 'THIS', 'ARG', 'LCL']:
            self.writeln('@' + end_frame)
            self.writeln('D=M')
            self.writeln('@' + str(i))
            self.writeln('D=D-A')
            self.writeln('A=D')
            self.writeln('D=M')
            self.writeln('@' + segment)
            self.writeln('M=D')
            i += 1

        # goto retAddr
        self.writeln('@' + ret_addr)
        self.writeln('A=M')
        self.writeln('0;JMP')

    def write_arithmetic(self, command: str):
        if command not in ['neg', 'not']:  # no need to pop from stack for unary ops
            self.stack_to_d()
        self.decrement_sp()
        self.writeln('@SP')
        self.writeln('A=M')

        if command == 'add':
            self.writeln('M=M+D')
        elif command == 'sub':
            self.writeln('M=M-D')
        elif command == 'and':
            self.writeln('M=M&D')
        elif command == 'or':
            self.writeln('M=M|D')
        elif command == 'neg':
            self.writeln('M=-M')
        elif command == 'not':
            self.writeln('M=!M')
        elif command in ['eq', 'gt', 'lt']:
            self.writeln('D=M-D')
            self.writeln('@COND{}'.format(self.cond_count))

            if command == 'eq':
                self.writeln('D;JEQ')  # M = D
            if command == 'gt':
                self.writeln('D;JGT')  # M > D
            if command == 'lt':
                self.writeln('D;JLT')  # M < D

            self.writeln('@SP')
            self.writeln('A=M')
            self.writeln('M=0')  # false
            self.writeln('@ENDCOND{}'.format(self.cond_count))
            self.writeln('0;JMP')

            self.writeln('(COND{})'.format(self.cond_count))
            self.writeln('@SP')
            self.writeln('A=M')
            self.writeln('M=-1')  # true

            self.writeln('(ENDCOND{})'.format(self.cond_count))
            self.cond_count += 1
        else:
            raise Exception('Unconown command {}'.format(command))
        self.increment_sp()

    def write_push_pop(self, command: str, segment: str, index: int):
        self.write_address(segment, index)
        if command == 'push':
            if segment == 'constant':
                self.writeln('D=A')
            else:
                self.writeln('D=M')
            self.d_to_stack()
        elif command == 'pop':
            self.writeln('D=A')
            self.writeln('@R13')
            self.writeln('M=D')
            self.stack_to_d()
            self.writeln('@R13')
            self.writeln('A=M')
            self.writeln('M=D')
        else:
            raise Exception('Unknown command')

    def write_address(self, segment, index):
        if segment == 'constant':
            self.writeln('@' + str(index))
        elif segment == 'static':
            self.writeln('@' + self.current_file + '.' + str(index))
        elif segment in ['local', 'argument', 'this', 'that']:
            self.writeln('@' + CodeWriter.ADDRESSES[segment])
            self.writeln('D=M')
            self.writeln('@' + str(index))
            self.writeln('A=D+A')
        elif segment in ['pointer', 'temp']:
            self.writeln('@R' + str(CodeWriter.ADDRESSES[segment] + int(index)))
        else:
            raise Exception('Wrong address')

    def writeln(self, cmd):
        self.asm.append(cmd)

    def d_to_stack(self):
        self.writeln('@SP')
        self.writeln('A=M')
        self.writeln('M=D')
        self.writeln('@SP')
        self.writeln('M=M+1')

    def stack_to_d(self):
        self.writeln('@SP')
        self.writeln('M=M-1')
        self.writeln('A=M')
        self.writeln('D=M')

    def decrement_sp(self):
        self.writeln('@SP')
        self.writeln('M=M-1')

    def increment_sp(self):
        self.writeln('@SP')
        self.writeln('M=M+1')

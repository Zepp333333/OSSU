from command import Command


class Parser:
    """
    Handles the parsing of a single .vm file
    Reads a VM command, parses the command into its lexical components
    and provides convenient access to these components.
    Ignores all white space and comments
    """

    def __init__(self, in_file: str):
        self.in_file = in_file.splitlines()
        self.in_file = [line.split('//')[0] for line in self.in_file]  # remove comments
        self.in_file = [line for line in self.in_file if line]  # remove empty
        self.num_lines = len(self.in_file)
        self.current_line = 0
        self.current_command = Command([])

    def has_more_commands(self) -> bool:
        return self.current_line < self.num_lines

    def advance(self) -> None:
        line = self.in_file[self.current_line]
        self.current_command = Command(line.split())
        self.current_line += 1

    def get_current_command(self):
        return self.current_command

    def command_type(self) -> str:
        return self.current_command.get_command_type()

    def arg1(self) -> str:
        return self.current_command.get_arg1()

    def arg2(self) -> int:
        return self.current_command.get_arg2()

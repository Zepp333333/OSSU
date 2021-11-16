"""
Asks the user for two numbers and prints the result
of the first number minus the second number.
"""

def main():
    print('This program subtracts one number from another.')
    first = float(input('Enter first number: '))
    second = float(input('Enter second number: '))
    print(f'The result is {first - second}')


if __name__ == '__main__':
    main()

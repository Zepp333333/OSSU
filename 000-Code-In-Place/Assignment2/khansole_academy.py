"""
Prints out a randomly generated addition problem
and checks if the user answers correctly.
"""

import random

def main():
    n1 = random.randint(10,99)
    n2 = random.randint(10,99)
    sum = n1 + n2
    print(f'What is {n1} + {n2}?')
    result = int(input('Your answer: '))
    if result == sum:
        print('Correct!')
    else:
        print(f'Incorrect.The expected answer is {sum}')


if __name__ == '__main__':
    main()

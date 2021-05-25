"""
Prints out a randomly generated addition problem
and checks if the user answers correctly.
"""

import random

MAX_CORRECT_ANSWERS = 3


def main():
    correct_answers = 0
    while correct_answers < MAX_CORRECT_ANSWERS:
        if play_round():
            correct_answers += 1
            print(f'Correct! You\'ve gotten {correct_answers} correct in a row.')
        else:
            correct_answers = 0
    print('Congratulations! You mastered addition.')


def play_round() -> bool:
    n1 = random.randint(10, 99)
    n2 = random.randint(10, 99)
    sum = n1 + n2
    print(f'What is {n1} + {n2}?')
    result = int(input('Your answer: '))
    if result == sum:
        return True
    else:
        print(f'Incorrect.The expected answer is {sum}')
        return False


if __name__ == '__main__':
    main()

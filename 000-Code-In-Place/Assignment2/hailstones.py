"""
Produce Hailstone sequence based on User input
"""


def main():
    number = int(input('Enter a number: '))

    while number > 1:
        if is_even(number):
            new_number = number // 2
            print(f'{number} is even, so I take half: {new_number}')
            number = new_number
        else:
            new_number = number * 3 + 1
            print(f'{number} is odd, so I make 3n+1: {new_number}')
            number = new_number


def is_even(n):
    return n % 2 == 0


if __name__ == "__main__":
    main()

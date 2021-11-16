"""
TODO: Write a description here
"""

import random

INITIAL_STONES = 20

def main():
    stones = INITIAL_STONES
    player = 0
    win = False
    while not win:
        stones -= remove_stones(stones, player % 2 + 1)
        player += 1
        if stones == 0:
            win = True
            print(f'Player {player % 2 + 1} wins!')


def remove_stones(stones, player):
    print(f'There are {stones} stones left')
    amount = int(input(f'Player {player} would you like to remove 1 or 2 stones? '))

    while not check_correct(amount):
        amount = int(input("Please enter 1 or 2: "))
    print()
    return amount


def check_correct(amount):
    return True if 0 < amount < 3 else False


if __name__ == '__main__':
    main()

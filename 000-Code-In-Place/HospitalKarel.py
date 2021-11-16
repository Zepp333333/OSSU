from stanfordkarel import *

# File: HospitalKarel.py
# -----------------------------
# Here is a place to program your Section problem


def turn_right():
    for i in range(3):
        turn_left()

def build_hospital():
    turn_left()
    #build first column
    for i in range(2):
        move()
        put_beeper()

    turn_right()
    move()
    turn_right()

    # build second column
    put_beeper()
    for i in range(2):
        move()
        put_beeper()
    turn_left()


def main():
    """
    You should write your code to make Karel do its task in
    this function. Make sure to delete the 'pass' line before
    starting to write your own code. You should also delete this
    comment and replace it with a better, more descriptive one.
    """
    if beepers_present():
        build_hospital()
    while front_is_clear():
        move()
        if beepers_present():
            build_hospital()

if __name__ == '__main__':
    run_karel_program('HospitalKarel2.w')

MAX_NUM = 35


def factorial(x):
    """

    :param x:
    :return:
    >>> factorial(3)
    6
    >>> factorial(1)
    1
    >>> factorial(0)
    0
    """
    if x == 0:
        return 1
    elif x == 1:
        return x
    else:
        return x * factorial(x - 1)


def main():
    for i in range(MAX_NUM):
        print(i, factorial(i))


# if __name__ == '__main__':
#     main()

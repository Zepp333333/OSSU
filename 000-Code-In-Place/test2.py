"""
Part A:
"10" will be printed, as divide_and_round doesn't return anything
"""

"""
Part B: 
Edit this code so that it works correctly
"""

def divide_and_round(n):
    """
    Divides an integer n by 2 and rounds 
    up to the nearest whole number
    """
    if n % 2 == 0:
        return  n / 2
    else:
        return (n + 1) / 2

def main():
    n = 10
    print(divide_and_round(n))



if __name__ == '__main__':
    main()

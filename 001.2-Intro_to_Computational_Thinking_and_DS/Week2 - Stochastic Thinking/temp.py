import random
def genEven():
    '''
    Returns a random even number x, where 0 <= x < 100
    '''
    return random.randrange(0, 100, 2)


def stochasticNumber():
    '''
    Stochastically generates and returns a uniformly distributed even number between 9 and 21
    '''
    l = [i for i in range(9,21) if i % 2 == 0]
    return random.choice(l)

print(stochasticNumber())

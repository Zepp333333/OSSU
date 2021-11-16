import traceback


def boxPrint(symbol, width, height):
    if len(symbol) != 1:
        raise Exception('symbol needs to be a string of lenght 1')
    if (width < 2) or (height < 2):
        raise Exception('Width and Height should be 2 or more')
    print(symbol * width)
    for i in range(height - 2):
        print(symbol + (' ' * (width - 2) ) + symbol)
    print(symbol * width)

boxPrint('**', 20, 5)

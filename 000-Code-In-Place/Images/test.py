from simpleimage import SimpleImage


def darker(image):
    for pixel in image:
        pixel.red = pixel.red // 2
        pixel.green = pixel.green // 2
        pixel.blue = pixel.blue // 2


def red_channel(filename):
    image = SimpleImage(filename)
    for pixel in image:
        pixel.green = 0
        pixel.blue = 0
    return image


def compute_luminocity(red, green, blue):
    return (0.299 * red) + (0.587 * green) + (0.114 * blue)


def grayscale(filename):
    image = SimpleImage(filename)
    for pixel in image:
        luminocity = compute_luminocity(pixel.red, pixel.green, pixel.blue)
        pixel.red = luminocity
        pixel.green = luminocity
        pixel.blue = luminocity
    return image


def main():
    # my_image = SimpleImage('IMG-20160728-WA0000.jpg')
    # darker(my_image)
    # my_image.show()

    grayscale('IMG-20160728-WA0000.jpg').show()


if __name__ == '__main__':
    main()


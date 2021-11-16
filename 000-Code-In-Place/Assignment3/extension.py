
from simpleimage import SimpleImage

RESIZE_FACTOR = 2


def make_reflected(filename):
    image = SimpleImage(filename)
    new_image = SimpleImage.blank(image.width, image.height * 2)
    height = new_image.height
    for pixel in image:
        new_image.set_pixel(pixel.x, pixel.y, pixel)
        new_image.set_pixel(pixel.x, height - pixel.y - 1 , pixel)

    return new_image


def resize(filename, factor):
    image = SimpleImage(filename)
    new_image = SimpleImage.blank(image.width * factor, image.height * factor)
    for pixel in image:
        new_image.set_pixel(pixel.x * factor, pixel.y * factor, pixel)
        new_image.set_pixel(pixel.x * factor + 1, pixel.y * factor, pixel)
        new_image.set_pixel(pixel.x * factor, pixel.y * factor + 1, pixel)
        new_image.set_pixel(pixel.x * factor + 1, pixel.y * factor + 1, pixel)



    return new_image



def main():
    """
    Resiszes the image trough simple pixel multiplication
    """
    original = SimpleImage('images/tiefighter.jpg')
    original.show()
    reflected = resize('images/tiefighter.jpg', RESIZE_FACTOR)
    reflected.show()


if __name__ == '__main__':
    main()

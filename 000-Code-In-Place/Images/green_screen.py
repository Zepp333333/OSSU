from simpleimage import SimpleImage

INTENSITY_THRESHOLD = 1.6


def greenscreen(main_filename, back_filename):
    image = SimpleImage(main_filename)
    back = SimpleImage(back_filename)
    for pixel in image:
        average = (pixel.red + pixel.green + pixel.blue) // 3
        if pixel.green >= average * INTENSITY_THRESHOLD:
            x = pixel.x
            y = pixel.y
            image.set_pixel(x.y, back.get_pixel(x, y))
    return image

"""
This program generates the Warhol effect based on the original image.
"""

from simpleimage import SimpleImage

N_ROWS = 2
N_COLS = 3
PATCH_SIZE = 222
WIDTH = N_COLS * PATCH_SIZE
HEIGHT = N_ROWS * PATCH_SIZE
PATCH_NAME = 'images/simba-sq.jpg'
SCALES = [
    [1.5, 0, 1.5],
    [1, 1.5, 0],
    [1, 1, 1],
    [0, 1, 1],
    [0.8, 0.8, 0.8],
    [0, 0, 1.5]
]


def main():
    patch_num = 0
    final_image = SimpleImage.blank(WIDTH, HEIGHT)
    for row in range(N_ROWS):
        for column in range(N_COLS):
            red_scale, green_scale, blue_scale = SCALES[patch_num]
            patch = make_recolored_patch(red_scale, green_scale, blue_scale)
            paste_patch(final_image, patch, column, row)
            patch_num += 1
    final_image.show()


def paste_patch(final_image, patch, column, row):
    for pixel in patch:
        final_image.set_pixel(pixel.x + (PATCH_SIZE * column), pixel.y + (PATCH_SIZE * row), pixel)
    return final_image


def make_recolored_patch(red_scale, green_scale, blue_scale):
    '''
    Implement this function to make a patch for the Warhol Filter. It
    loads the patch image and recolors it.
    :param red_scale: A number to multiply each pixels' red component by
    :param green_scale: A number to multiply each pixels' green component by
    :param blue_scale: A number to multiply each pixels' blue component by
    :return: the newly generated patch
    '''
    patch = SimpleImage(PATCH_NAME)
    for pixel in patch:
        pixel.red *= red_scale
        pixel.green *= green_scale
        pixel.blue *= blue_scale

    return patch


if __name__ == '__main__':
    main()

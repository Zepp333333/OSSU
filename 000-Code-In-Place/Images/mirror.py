from simpleimage import SimpleImage


image = SimpleImage('IMG-20160728-WA0000.jpg')
new_image = SimpleImage.blank(image.width, image.height)
width = image.width

for pixel in image:
    new_image.set_pixel(width - pixel.x-1, pixel.y, pixel)

new_image.show()

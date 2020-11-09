#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Jan 31 15:44:19 2020

@author: Sergey
"""

#A regular polygon has n number of sides. Each side has length s.
#
#The area of a regular polygon is:  0.25∗𝑛∗𝑠2𝑡𝑎𝑛(𝜋/𝑛) 
#The perimeter of a polygon is: length of the boundary of the polygon
#Write a function called polysum that takes 2 arguments, n and s. This function should sum the area and square of the perimeter of the regular polygon. The function returns the sum, rounded to 4 decimal places.



from math import tan, pi

def polysum(n, s):
    '''
    Integer, Float -> Float
    Returns sum of area and squared perimeter of the regular polygon rounded to 4 decimals
        Int   n is number of sides
        Float s lentgh of each side
    '''
    area = (0.25*n*(s**2))/tan(pi/n)
    perimeter = (s * n)
    return round((perimeter**2) + area, 4)


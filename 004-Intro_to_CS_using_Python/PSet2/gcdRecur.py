#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Jan 31 14:09:44 2020

@author: Sergey
"""

#A clever mathematical trick (due to Euclid) makes it easy to find greatest common divisors. Suppose that a and b are two positive integers:
#
#If b = 0, then the answer is a
#
#Otherwise, gcd(a, b) is the same as gcd(b, a % b)

def gcdRecur(a, b):
    '''
    a, b: positive integers
    
    returns: a positive integer, the greatest common divisor of a & b.
    '''
    
    
    
    
    if b == 0:
        return a
    else:
        return gcdRecur(b, a % b)
    
    

print(gcdRecur(12, 2))  #= 2
print(gcdRecur(12, 6))  #= 6
print(gcdRecur(12, 9)) #= 3
print(gcdRecur(17, 12))# = 1    
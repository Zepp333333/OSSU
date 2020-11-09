#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Jan 31 14:01:44 2020

@author: Sergey
"""

def gcdIter(a, b):
    '''
    a, b: positive integers
    
    returns: a positive integer, the greatest common divisor of a & b.
    '''


    if(a < b):
        guess = a
    else:
        guess = b
        
    while guess >= 1:
        if a%guess == 0 and b%guess == 0:
            return guess
            break
        else:
            guess -= 1



print(gcdIter(2, 12))  #= 2
print(gcdIter(6, 12))  #= 6
print(gcdIter(9, 12)) #= 3
print(gcdIter(17, 12))# = 1


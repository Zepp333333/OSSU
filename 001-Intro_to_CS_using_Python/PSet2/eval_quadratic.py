#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Jan 30 20:36:48 2020

@author: Sergey
"""

def evalQuadratic(a, b, c, x):
    '''
    Write a Python function, evalQuadratic(a, b, c, x), that returns the value of the quadratic  𝑎⋅𝑥2+𝑏⋅𝑥+𝑐 .
    a, b, c: numerical values for the coefficients of a quadratic equation
    x: numerical value at which to evaluate the quadratic.
    '''
    # Your code here
    return(a*x**2 + b*x + c)
#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Jan 31 11:49:56 2020

@author: Sergey
"""

a = 2
b = 3

def mult(a, b):
    if b == 1:
        return a
    else:
        return a + mult(a, b-1)
        

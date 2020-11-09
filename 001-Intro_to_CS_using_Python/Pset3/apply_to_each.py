#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Feb  5 18:51:53 2020

@author: Sergey
"""

def applyToEach(L, f):
    for i in range(len(L)):
        L[i] = f(L[i])
        
testList = [1, -4, 8, -9]

def sq(x):
    return x * x

applyToEach(testList, sq)

print(testList)

        
        

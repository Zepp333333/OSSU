#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Feb 28 12:53:21 2020

@author: Sergey
"""

def genPrimes():
    p = 2
    while True:
        if checkPrime(p):
            next = p
            yield next
        p+=1


def checkPrime(n):
    # asume n is integer >= 2
    if n == 2:
        return True
    else:
        for i in range(2, round(n**0.5)+1):
            if n % i == 0:
                return False
    return True
    
    
p = genPrimes()
      

#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Jan 31 11:55:03 2020

@author: Sergey
"""

n = 5
x = 0
def fact(n):
    if n == 1:
        return 1
    else:
        return n * fact (n - 1)
        
#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Jan 24 09:42:03 2020

@author: Sergey
"""

# =============================================================================
# Assume s is a string of lower case characters.
# 
#  Write a program that prints the number of times
#  the string 'bob' occurs in s. For example, 
#  if s = 'azcbobobegghakl', then your
#  program should print
# 
# Number of times bob occurs is: 2
# =============================================================================

s = 'azcbobobobegghaklnbob'

k = 'bob'
result = 0
pos = 0

while pos < len(s):
    t = s.find(k, pos)
    if t == -1:
        break
    pos = t + 1
    result += 1

print(result)
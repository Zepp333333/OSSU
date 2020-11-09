#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Jan 24 09:33:26 2020

@author: Sergey Sazonov
"""


# =============================================================================
# Assume s is a string of lower case characters.
# 
# Write a program that counts up the number of 
# vowels contained in the string s. Valid vowels 
# are: 'a', 'e', 'i', 'o', and 'u'. For example,
# if s = 'azcbobobegghakl', your program 
# should print: Number of vowels: 5
# =============================================================================

s = 'aeiouaeiou'
vowels = 'aeiou'
counter = 0
for c in s:
    for v in vowels:
        if c == v:
            counter +=1
            
print(counter)
            
            

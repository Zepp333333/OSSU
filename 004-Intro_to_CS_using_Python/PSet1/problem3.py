#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Jan 24 12:30:10 2020

@author: Sergey
"""

#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Jan 24 10:53:19 2020

@author: Sergey
"""

# =============================================================================
# Assume s is a string of lower case characters.
# 
# Write a program that prints the longest substring of s 
# in which the letters occur in alphabetical order. For example, 
# if s = 'azcbobobegghakl', then your program should print
# 
# Longest substring in alphabetical order is: beggh
# 
# In the case of ties, print the first substring. 
# For example, if s = 'abcbcd', then your program should print
# 
# Longest substring in alphabetical order is: abc
# 
# Note: This problem may be challenging. We encourage you to
#  work smart. If you've spent more than a few hours on this 
#  problem, we suggest that you move on to a different part 
#  of the course. If you have time, come back to this problem
#  after you've had a break and cleared your head.
# =============================================================================

#s = 'azcbobobegghakl'
#s = 'bobegghakl'
#s = 'azcbobobegghaklmnopqr'
#s = 'abcbcd'
#s = 'qgvnenhfhvxxetssoseo'
#s = 'ohfhvxxetssoseo'
#s = 'kqsdcbwzfbos'
#s = 'noifexipnwapzzgqahsu'
#s = 'zyxwvutsrqponmlkjihgfedcba'
#s = 'xuoscxeqvqnbusdlnea'
#s = 'kulvbymmhggsoq'
#s = 'vvspsrblr'
s = 'abcdefghijklmnopqrstuvwxyz'
# s = 'bsrelepofahxiorz'



sub = s[0]
result = ""
for i in range(1, len(s)):
    c = s[i]
    if (ord(c)) >= ord(sub[-1]):
        sub = sub + c 
    else:
        if len(sub) > len (result):
            result = sub
        sub = c
        
if len(sub) > len (result):
    result = sub

print(result)




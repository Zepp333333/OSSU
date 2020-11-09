#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Feb  5 18:39:10 2020

@author: Sergey
"""

def oddTuples(aTup):
    '''
    aTup: a tuple
    
    returns: tuple, every other element of aTup. 
    '''
    out = ()
    for i in range(0 , len(aTup), 2):
        out += aTup[i:i+1]
    return out    
        
    
    
t = ('I', 'am', 'a', 'test', 'tuple')
print(oddTuples(t))
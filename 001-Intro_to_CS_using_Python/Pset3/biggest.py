#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Feb  6 12:41:28 2020

@author: Sergey
"""

animals = { 'a': ['aardvark'], 'b': ['baboon'], 'c': ['coati']}

animals['d'] = ['donkey']
animals['d'].append('dog')
animals['d'].append('dingo')

def biggest(aDict):
    '''
    aDict: A dictionary, where all the values are lists.

    returns: The key with the largest number of values associated with it
    '''
    val = aDict.values()
    best = max(val)
    res = None
    for k in aDict:
        if aDict[k] == best:
            res = k
            return res
       
         
    
biggest(animals)
#print(biggest(animals))
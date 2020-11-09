#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Mar  5 16:18:06 2020

@author: Sergey
"""

import math, random

#for n in range(1000, 100000, 1000):
#    print (n*math.log(n),  -3000*n)
##    print(5**n, n**5)


#def search(L, e):
#    for i in range(len(L)):
#        if L[i] == e:
#            return True
#        if L[i] > e:
#            return False
#        print(i)
#    return False
#
#
#
#
#def newsearch(L, e):
#    size = len(L)
#    for i in range(size):
#        if L[size-i-1] == e:
#            return True
#        if L[i] < e:
#            return False
#        print(i)
#    return False

def swapSort(L, p): 
    """ L is a list on integers """
    print("Original L: ", L)
    for i in range(len(L)):
        for j in range(len(L)):
            if L[j] < L[i]:
                # the next line is a short 
                # form for swap L[i] and L[j]
                L[j], L[i] = L[i], L[j] 
                print(i, j, L)
            p+=1
    print("Final L: ", L)
    print(p)

L = [1, 2, 3, 4, 5, 6, 7, 8, 9]
L = [1, 2, 3]
#print(search(L[:], 2))
#print(newsearch(L[:], 2))

L = [8, 3, 6, 2, 9, 5, 1, 4, 10, 7]
#L = []
#for i in range(100):
#    L.append( random.randrange(1000))
swapSort(L, 0)


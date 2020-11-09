#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Jan 31 12:30:27 2020

@author: Sergey
"""



#def printMove( s1, s2, s3, lines = 3):
#    print('iteration')
#    for l in range(lines, 0, -1): 
#        if (s1 >= l):
#            print('- ', end='') 
#        else:
#            print('  ', end='')
#        if (s2 >= l):
#            print('- ', end='') 
#        else:
#            print('  ', end='')
#        if (s3 >= l):
#            print('- ', end='')  
#        else:
#            print('  ', end='')
#        print('')

def printMove(fr, to, spare):
    print(str(fr) + " " + str (to) + " " + str(spare))

def hanoi(n, fr, to, spare):
    if n == 1:
        printMove(fr, to, spare)
    else:
        hanoi(n-1, fr, spare, to)
        hanoi(1, fr, to, spare)
        hanoi(n-1, spare, to, fr)
        
hanoi(3, 3, 0, 0)


#def printMove(fr, to, spare):
#    print(str(fr) + " " + str (to) + " " + str(spare))
#
#def hanoi(n, fr, to, spare):
#    if n == 1:
#        printMove(fr, to, spare)
#    else:
#        hanoi(n-1, fr, spare, to)
#        hanoi(1, fr, to, spare)
#        hanoi(n-1, spare, to, fr)
#        
#hanoi(4, 4, 0, 0)
        
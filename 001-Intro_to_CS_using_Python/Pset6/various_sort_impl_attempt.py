#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Mar  5 16:18:06 2020

@author: Sergey
"""
import random
def bubbleSort(L):
  
   swap = False 
   while not swap: 
       swap = True
       for i in range(len(L)-1):
            print(L, i,  L == sorted(L))
            if L[i] > L[i+1]:
                swap = False
                tmp = L[i]
                L[i] = L[i+1]
                L[i+1] = tmp
                
def selectionSort(L):
    for i in range(len(L)):
        print(L)
        for j in range(i+1, len(L)):
            if L[j] < L[i]:
#                tmp = L[i]
#                L[i] = L[j]
#                L[j] = tmp
                L[i], L[j] = L[j], L[i]
    
    
def mergeSort(L):
        

#def swap(L, j, i):
#    tmp = L[i]
#    L[i] = L[j]
#    L[j] = tmp
#    return L    
    
    
#L = []   
#for i in range(19):
#    L.append(random.randint(0, 1000))
#bubbleSort(L)

L = [8,
 4,
 9,
 1,
 3,
 5,
 2]
bubbleSort(L[:])
selectionSort(L[:])

    
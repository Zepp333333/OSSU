#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Feb 26 21:38:14 2020

@author: Sergey
"""

class intSet(object):
    """An intSet is a set of integers
    The value is represented by a list of ints, self.vals.
    Each int in the set occurs in self.vals exactly once."""

    def __init__(self):
        """Create an empty set of integers"""
        self.vals = []

    def insert(self, e):
        """Assumes e is an integer and inserts e into self""" 
        if not e in self.vals:
            self.vals.append(e)

    def member(self, e):
        """Assumes e is an integer
           Returns True if e is in self, and False otherwise"""
        return e in self.vals

    def remove(self, e):
        """Assumes e is an integer and removes e from self
           Raises ValueError if e is not in self"""
        try:
            self.vals.remove(e)
        except:
            raise ValueError(str(e) + ' not found')

    def __str__(self):
        """Returns a string representation of self"""
        self.vals.sort()
        return '{' + ','.join([str(e) for e in self.vals]) + '}'
    
    def intersect(self, other):
        r = intSet()
        for x in self.vals:
            if x in other.vals:
                r.insert(x)
        return(r)

    def __len__(self):
        r = 0
        for i in self.vals:
            r +=1
        return r
    
    

a = intSet()
a.insert(1)
a.insert(2)
a.insert(3)


b = intSet()
b.insert(3)
b.insert(2)
#b.insert(6)

print(a.intersect(b))
#print(a.len())
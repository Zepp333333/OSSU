#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Jan 30 10:37:40 2020

@author: Sergey
"""


bot_range = 0
top_range = 100
guess = round(top_range/2)


print('Please think of a number between 0 and 100!')


while True:
    print('Is your secret number ' + str(guess) + '?')
    inpt = input("Enter \'h\' to indicate the guess is too high. Enter \'l\' to indicate the guess is too low. Enter \'c\' to indicate I guessed correctly. ")
    if inpt == 'c':
        print('Game over. Your secret number was: ' + str(guess))
        break
    elif inpt == 'l':
        bot_range = guess
        guess = bot_range + (top_range - bot_range)//2

    elif inpt == 'h':
        top_range = guess
        guess = bot_range + (top_range - bot_range)//2

    else:
        print('Sorry, I did not understand your input.')
        
        
    

         
        
        
    
#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Jan 31 17:05:41 2020

@author: Sergey

Float, Float -> Float
Calculates minimum monthly payment amount to pay off Credit Card debt within 12 month
using bisection approach

Parameters:
    - initial balance on the CC
    - annual interest rate

"""

#Test Case 1:
#balance = 320000
#annualInterestRate = 0.2
#
#Result Your Code Should Generate:
# -------------------
#Lowest Payment: 29157.09


#Test Case 2:
balance = 999999
annualInterestRate = 0.18
	      
#Result Your Code Should Generate:
#-------------------
#Lowest Payment: 90325.03


def rembal(balance, mPayment, monthlyIR, period):
    '''
    Float float, float, Integer -> Float
    Retuns calcuation of remaining balance on CC based on initial balance, monthly payment, monthly IR and num of month
        - Float balance - initial balance
        - Float mPayment - monthly payment
        - Float montlyIR - monthly interest rate
        - Int period - number of month ot compute
    '''
    for i in range(period):
        m_unpaidBallance = balance - mPayment
        balance = (m_unpaidBallance + (monthlyIR * m_unpaidBallance))
    return balance
        


monthlyIR = annualInterestRate/12              #- monthly interest rate
period = 12                                    #- depth of the calculation in month

# setting lower bound to 1/12 of balance
lBound = balance / 12

# setting upper bound to 1/12 of 12 month balance with coumpund interest rate
uBound = balance
for i in range(12):
    uBound = uBound + balance * monthlyIR
uBound = uBound / 12

  
guess = lBound + (uBound - lBound) / 2

while True:
    remainingBalance = rembal(balance, guess, monthlyIR, period)
    
    if remainingBalance  > 0 and remainingBalance  <= 0.01:
        print('Lowest Payment:', round(guess, 2))
        break
    elif remainingBalance  > 0.01:
        lBound = guess
        guess = lBound + (uBound - lBound) / 2
    elif remainingBalance < 0:
        uBound = guess
        guess = lBound + (uBound - lBound) / 2
    

    
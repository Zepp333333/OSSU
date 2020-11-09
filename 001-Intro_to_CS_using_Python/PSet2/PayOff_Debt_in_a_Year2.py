#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Jan 31 17:05:41 2020

@author: Sergey

Float, Float -> Float
Calculates minimum monthly payment amount to pay off Credit Card debt within 12 month

Parameters:
    - initial balance on the CC
    - annual interest rate

"""

#Test Case 1:  310
balance = 3329
annualInterestRate = 0.2

 #Test Case 2: 440
#balance = 4773
#annualInterestRate = 0.2


monthlyIR = annualInterestRate/12              #- monthly interest rate
period = 12                                    #- depth of the calculation in month
remainingBalance = balance                     #- ballance remaining afterh monthly paymment and interes accurals 

mPayment = 0

while remainingBalance > 0:
    mPayment +=10
    remainingBalance = balance  
    for i in range(period):
        m_unpaidBallance = remainingBalance - mPayment
        remainingBalance = m_unpaidBallance + (monthlyIR * m_unpaidBallance)

        
            
    
print('Lowest Payment:', mPayment)
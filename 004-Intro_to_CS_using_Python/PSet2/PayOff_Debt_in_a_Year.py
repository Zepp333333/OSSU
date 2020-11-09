#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Jan 31 16:46:38 2020

@author: Sergey

Float, Float, Float -> Float
Calculates the outstanding balance on the Credit Card after 12 month based on
minimal paymnet alowed by bank
Parameters:
    - initial balance on the CC
    - annual interest rate
    - minimal monthly payment rate
"""

#test-cases below

#balance  = 42                   #- the outstanding balance on the credit card
#annualInterestRate = 0.2        #- annual interest rate as a decimal
#monthlyPaymentRate = 0.04       #- minimum monthly payment rate as a decimal

#balance = 484; annualInterestRate = 0.2; monthlyPaymentRate = 0.04
#balance = 241; annualInterestRate = 0.22; monthlyPaymentRate = 0.06
#balance = 487; annualInterestRate = 0.15; monthlyPaymentRate = 0.06
balance = 333; annualInterestRate = 0.22; monthlyPaymentRate = 0.08

monthlyIR = annualInterestRate/12              #- monthly interest rate
period = 12                                    #- depth of the calculation in month
remainingBalance = balance                     #- ballance remaining afterh monthly paymment and interes accurals 

for i in range(period):
    m_payment = remainingBalance * monthlyPaymentRate
    m_unpaidBallance = remainingBalance - m_payment
    remainingBalance = m_unpaidBallance + (monthlyIR * m_unpaidBallance)
    
print('Remaining balance:', round(remainingBalance, 2))
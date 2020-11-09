#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Mar  2 11:13:49 2020

@author: Sergey
"""

from ps6 import *

# apply_shift tests
#shift = 1
#msg = Message('I want it all')
#print(msg.apply_shift(shift))

# PlaitextMessage tests
#shift = 2
#pmsg = PlaintextMessage('1.hello!!', shift)
#print(pmsg.get_message_text())
##print(pmsg.get_shift())
##print(pmsg.get_encrypting_dict())
##print(pmsg.get_message_text_encrypted())
##pmsg.change_shift(0)
#print(pmsg.get_shift())
#print(pmsg.get_encrypting_dict())
#print(pmsg.get_message_text_encrypted())

# CiphertextMessage tests
cmsg = CiphertextMessage(get_story_string())
print(cmsg.get_message_text())
print(cmsg.decrypt_message())



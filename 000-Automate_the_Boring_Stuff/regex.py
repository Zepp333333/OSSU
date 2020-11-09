import re

# find a pattern
message = 'Call me 415-555-1011 tomorrow or at 415-555-9999 on sunday'
phoneNumRegex = re.compile(r'\d\d\d-\d\d\d-\d\d\d\d')
mo = phoneNumRegex.search(message)
print('find a match: ' + mo.group())

# find all pattern matches
mo = phoneNumRegex.findall(message)
print('find all matches: ' + str(mo))

# grouping - find area code
message = 'Call me 415-555-1011 tomorrow or at 415-555-9999 on sunday'
phoneNumRegex = re.compile(r'(\d\d\d)-(\d\d\d-\d\d\d\d)')
mo = phoneNumRegex.search(message)
print('find group 1: ' + str(mo.group(1)))  # returns group 1
print('find group 2: ' + str(mo.group(2)))  # returns group 2

# matching "(" ")"

message = 'Call me (415) 555-1011 tomorrow or at 415-555-9999 on sunday'
phoneNumRegex = re.compile(r'\(\d\d\d\) \d\d\d-\d\d\d\d')
mo = phoneNumRegex.search(message)
print('Find parentheses: ' + mo.group())

# pipes
batRegex = re.compile(r'Bat(man|mobile|copter|bat)')
mo = batRegex.search('Batmobile lost a wheel')
print('Pipes 1: ' + mo.group())





'''def isPhoneNumber(text):
    if len(text) != 12:
        return False
    for i in range(0,3):
        if not text[i].isdecimal():
            return False
        if text[3] != '-':
            return False
        for i in range(4,7):
            if not text[i].isdecimal():
                return False
        if text[7] != '-':
            return False
        for i in range(8, 12):
            if not text[i].isdecimal():
                return False
        return True


message = 'Call me 415-555-1011 tomorrow or at 415-555-9999 on sunday'
foundNumber = False
for i in range(len(message)):
    chunk = message[i:i+12]
    if isPhoneNumber(chunk):
        print('Phone number found: ' + chunk)
        foundNumber = True
if not foundNumber:
    print('Could not find phone number')'''

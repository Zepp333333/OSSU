import re

# ? = group appears in the string 0 or 1 times
batRegex = re.compile(r'Batman|Batwoman')
batRegex = re.compile(r'Bat(wo)?man') # equivalent to previous
mo = batRegex.search('The Adventures of Batwoman')
print(mo.group())


phoneRegex = re.compile(r'(\d\d\d-)?\d\d\d-\d\d\d\d')
mo = phoneRegex.search('My phone number is 555-1234')
print(mo.group())

# * match zero or more times
batRegex = re.compile(r'Bat(wo)*man')
mo = batRegex.search('Adventures of Batwowowowoman')
print(mo.group())

# + match one ore more times
batRegex = re.compile(r'Bat(wo)+man')
mo = batRegex.search('Adventures of Batwowoman')
print(mo.group())

# escaping characters
regex = re.compile(r'(\+\*\?)+')
mo = regex.search('I learned +*?+*?')
print(mo.group())

# {} - matching exact number of times
haRegex = re.compile(r'(Ha){3}')
mo = haRegex.search('He said HaHaHa')
print(mo.group())

# find 3 phone numbers in a row
phoneRegex = re.compile(r'((\d\d\d-)?\d\d\d-\d\d\d\d(,)?){3}')
mo = phoneRegex.search('My numbers are 415-555-1234,555-4242,212-555-9999')
print(mo.group())

# march a range of repetitions
haRegex = re.compile(r'(Ha){3,5}')
mo = haRegex.search('He said HaHaHaHaHaHa')
print(mo.group())

digitRegex = re.compile(r'(\d){3,5}')
mo = digitRegex.search('1234567890')  # returns first five as it matches the longest sting (greedy)
print(mo.group())
digitRegex = re.compile(r'(\d){3,5}?')
mo = digitRegex.search('1234567890') # returns first three as it matchess shortest string (non-greedy)
print(mo.group())






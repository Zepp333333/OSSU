import re

# findall will return tuples if groups present in regex
phoneRegex = re.compile(r'(\d\d\d)-(\d\d\d-\d\d\d\d)')
# return tuples of 2
mo = phoneRegex.findall('My numbers are 415-555-1234,555-4242,212-555-9999')
print(mo)
# return tuples of 3
phoneRegex = re.compile(r'((\d\d\d)-(\d\d\d-\d\d\d\d))')
mo = phoneRegex.findall('My numbers are 415-555-1234,555-4242,212-555-9999')
print(mo)


# Character classes

lyrics = '12 drummers drumming, 11 pipers piping, 10 lords a leaping, ' \
         '9 ladies dancing, 8 maids a milking, 7 swans a swimming, 6 geese ' \
         'a laying, 5 gold rings, 4 calling birds, 3 french hens, 2 turtle ' \
         'doves and 1 partridge in a pear tree.'

xmasRegex = re.compile(r'\d+\s\w+')
mo = xmasRegex.findall(lyrics)
print(mo)

vowelRegex = re.compile(r'[aeiouAEIOU]')  # r'(a|e|i|o|u)'
mo = vowelRegex.findall('Robocop eats baby food')
print(mo)

doublevowelRegex = re.compile(r'[aeiouAEIOU]{2}')  # r'(a|e|i|o|u)'
mo = doublevowelRegex.findall('Robocop eats baby food')
print(mo)

# negative character classes
consonantsRegex = re.compile(r'[^aeiouAEIOU]')
mo = consonantsRegex.findall('Robocop eats baby food')
print(mo)

# Carrot (^) sign - find text in the beginning of a string
beginsWithHelloRegex = re.compile(r'^Hello')
mo = beginsWithHelloRegex.search('Hello there!')
print(mo.group())

# match ends with ($)
endsWithWordRegex = re.compile(r'world!$')
mo = endsWithWordRegex.search('Hello world!')
print(mo.group())

allDigitsRegex = re.compile(r'^\d+$') # whole string should be digits ^ and $
mo = allDigitsRegex.search('123123123123123')
print(mo.group())

# dot - ant character but the new ine
atRegex = re.compile(r'.at')
mo = atRegex.findall('The cat in the hat sat on the flat mat.')
print(mo)

atRegex = re.compile(r'.{1,2}at') # this will include spaces
mo = atRegex.findall('The cat in the hat sat on the flat mat.')
print(mo)

# dot start .* = any pattern
text = 'First Name: Sergey Last Name: Sazonov'
nameRegex = re.compile(r'First Name: (.*) Last Name: (.*)')
mo = nameRegex.findall(text)
print(mo)

text = '<To serve humans> for dinner.>'
nonegreedy = re.compile(r'<(.*?)>')
mo = nonegreedy.findall(text)
print(mo)

greedy = re.compile(r'<(.*)>')
mo = greedy.findall(text)
print(mo)


prime = 'Serve the public trust.\nProtect the innocent.\nUplod the law.'
print(prime)
dotStar = re.compile(r'.*')
mo = dotStar.search(prime)
print(mo.group())
dotStar = re.compile(r'.*', re.DOTALL)  # dot includes new line
mo = dotStar.search(prime)
print(mo.group())


vowelRegex = re.compile(r'[aeiou]')
mo = vowelRegex.findall('Al, why does your programming book talk about RoboCop so much?')
print(mo)
vowelRegex = re.compile(r'[aeiou]', re.I) #case insensetive
mo = vowelRegex.findall('Al, why does your programming book talk about RoboCop so much?')
print(mo)

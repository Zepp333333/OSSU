#! /usr/bin/python3

import re
import pyperclip

# Create regex for phone number
phoneRegex = re.compile(r'''
# 415-555-1233, 555-3432, (415) 555-0000, 555-0934 ext 12345, ext. 12345, x12345
(
((\d\d\d)|(\(\d\d\d\)))?    # area code (optional)
(\s|-)                      # first separator 
\d\d\d                      # first 3 digits
-                           # separator
\d\d\d\d                    # last 4 digits
(((ext(\.)?\s)|x)           # extension word part (optional)
(\d{2,5}))?                 # extension number part (optional)
)
''', re.VERBOSE)

# Create a regex for email adressess
emailRegex = re.compile(r'''
# some.+_thing@some.+_thing.com
[a-zA-Z0-9_.+]+              # name part
@                            # @ symbol
[a-zA-Z0-9_.+]+              # domain_name part
''', re.VERBOSE)

# Get the text of the clipboard
text = pyperclip.paste()

# Extract the email/phone from the text
exctractedPhone = phoneRegex.findall(text)
exctractedEmail = emailRegex.findall(text)
allPhoneNumbers = [n[0] for n in exctractedPhone]

# print(allPhoneNumbers)
# print(exctractedEmail)

# Copy the extracted email/phone to the clipboard
result = '\n'.join(allPhoneNumbers) + '\n' + '\n'.join(exctractedEmail)
pyperclip.copy(result)

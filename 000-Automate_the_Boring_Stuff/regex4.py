import re
namesRegex = re.compile(r'Agent \w+')
mo = namesRegex.findall('Agent Alice gave the secret to Agent Bob')
print(mo)
mo = namesRegex.sub('REDACTED', 'Agent Alice gave the secret to Agent Bob')
print(mo)

namesRegex = re.compile(r'Agent (\w)\w*')
mo = namesRegex.findall('Agent Alice gave the secret to Agent Bob')
print(mo)

mo = namesRegex.sub(r'Agent \1****', 'Agent Alice gave the secret to Agent Bob')
print(mo)

# Verbose mode
re.compile(r'''
(\d\d\d-)|      # area code (without parens, with dash)
(\(\d\d\d\) )   # - or- area code with parens and no dash
\d\d\d      # first 3 digits
-           # second dash
\d\d\d\d    # last 4 digits
\sx\d{2,3}  # extension, like x2345''', re.VERBOSE | re.DOTALL | re.IGNORECASE)




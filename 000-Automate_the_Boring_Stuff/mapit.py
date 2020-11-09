#! /Users/Sergey/Documents/OneDrive/Coding/OSSU/000-Automate_the_Boring_Stuff/venv/bin/python
import webbrowser
import sys
import pyperclip

sys.argv    # ['mapit.py, '870', 'Valencia', 'St.']

# check if command line args were passed
if len(sys.argv) > 1:
    address = ' '.join(sys.argv[1:])
else:
    address = pyperclip.paste()
# https://www.google.com/maps/place/<ADDRESS>
webbrowser.open('https://www.google.com/maps/place/' + address)

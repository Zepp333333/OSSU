# Hangman game
#

# -----------------------------------
# Helper code
# You don't need to understand this helper code,
# but you will have to know how to use the functions
# (so be sure to read the docstrings!)

import random
import string

WORDLIST_FILENAME = "words.txt"

def loadWords():
    """
    Returns a list of valid words. Words are strings of lowercase letters.
    
    Depending on the size of the word list, this function may
    take a while to finish.
    """
    print("Loading word list from file...")
    # inFile: file
    inFile = open(WORDLIST_FILENAME, 'r')
    # line: string
    line = inFile.readline()
    # wordlist: list of strings
    wordlist = line.split()
    print("  ", len(wordlist), "words loaded.")
    return wordlist

def chooseWord(wordlist):
    """
    wordlist (list): list of words (strings)

    Returns a word from wordlist at random
    """
    return random.choice(wordlist)

# end of helper code
# -----------------------------------

# Load the list of words into the variable wordlist
# so that it can be accessed from anywhere in the program
wordlist = loadWords()

def isWordGuessed(secretWord, lettersGuessed):
    '''
    secretWord: string, the word the user is guessing
    lettersGuessed: list, what letters have been guessed so far
    returns: boolean, True if all the letters of secretWord are in lettersGuessed;
      False otherwise
    '''
    res = 0
    for l in secretWord:
        if l in lettersGuessed:
            res += 1
    if res == len (secretWord):        
        return True
    else:
        return False



def getGuessedWord(secretWord, lettersGuessed):
    '''
    secretWord: string, the word the user is guessing
    lettersGuessed: list, what letters have been guessed so far
    returns: string, comprised of letters and underscores that represents
      what letters in secretWord have been guessed so far.
    '''
    res = ''
    for l in secretWord:
        if l in lettersGuessed:
            res = res + l
        else:
            res = res + '_' + ' '
    return res


def getAvailableLetters(lettersGuessed):
    '''
    lettersGuessed: list, what letters have been guessed so far
    returns: string, comprised of letters that represents what letters have not
      yet been guessed.
    '''
    
    abc = string.ascii_lowercase
    res = ''
    for l in abc:
        if l not in lettersGuessed:
            res += l
    return res
    

def get_input(a_mistakesMade, a_maxMistakes, a_availableLetters):
    print('You have ' + str(a_maxMistakes - a_mistakesMade) + ' guesses left.')
    print('Available letters: ' + a_availableLetters)
    g = input('Please guess a letter: ').lower() 
    while True:
        if (g not in string.ascii_lowercase) or (len(g) != 1):
            g = input('Please guess a letter: ').lower() 
        else: 
            break
    return g


def hangman(secretWord):
    '''
    secretWord: string, the secret word to guess.

    Starts up an interactive game of Hangman.

    * At the start of the game, let the user know how many 
      letters the secretWord contains.

    * Ask the user to supply one guess (i.e. letter) per round.

    * The user should receive feedback immediately after each guess 
      about whether their guess appears in the computers word.

    * After each round, you should also display to the user the 
      partially guessed word so far, as well as letters that the 
      user has not yet guessed.

    Follows the other limitations detailed in the problem write-up.
    '''
    # FILL IN YOUR CODE HERE...

    # Initializing variables
    lettersGuessed = []
    mistakesMade = 0
    maxMistakes = 8
    availableLetters = []
    availableLetters = getAvailableLetters(lettersGuessed)
    
    # Printing start of the game banner
    print('Welcome to the game, Hangman!')
    print('I am thinking of a word that is ' + str(len(secretWord)) + ' letters long.')
    print('-------------')
    
    
    while mistakesMade < maxMistakes:
        
        guess = get_input(mistakesMade, maxMistakes, availableLetters)
        if guess not in lettersGuessed:         #if its a new letter
            lettersGuessed.append(guess)
            availableLetters = getAvailableLetters(lettersGuessed)
            if guess in secretWord:
                print('Good guess: ' + getGuessedWord (secretWord, lettersGuessed))
                print('-------------')
                if isWordGuessed(secretWord, lettersGuessed):
                    print('Congratulations, you won!')
                    break
            else:                   #letter not in secretWord
                mistakesMade += 1
                print('Oops! That letter is not in my word: ' + getGuessedWord (secretWord, lettersGuessed))
                print('-------------')
            
        else:                                    #if input letter repeated
            print('Oops! You\'ve already guessed that letter: ' + getGuessedWord (secretWord, lettersGuessed))
            print('-------------')
    
    if not isWordGuessed(secretWord, lettersGuessed):
        print('Sorry, you ran out of guesses. The word was ' + secretWord + '.')


# When you've completed your hangman function, uncomment these two lines
# and run this file to test! (hint: you might want to pick your own
# secretWord while you're testing)

secretWord = chooseWord(wordlist).lower()
#secretWord = 'apple'
hangman(secretWord)

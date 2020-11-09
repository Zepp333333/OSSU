def stdDevOfLengths(L):
	'''

	:param L: list of strings
	:return: float std dev of the lingth of the strings
			or float('NaN') if L is empty
	'''

	if not L:
		return float('NaN')

	res = 0.0
	mu = 0.0
	for l in L:
		mu += l
	mu = mu / len(L)

	for t in L:
		res += (t - mu) ** 2
	res = (res / len(L))**0.5
	return res / mu

# test cases
print(stdDevOfLengths([1, 2, 3] ))
print(stdDevOfLengths([11, 12, 13] ))
print(stdDevOfLengths([0.1, 0.1, 0.1] ))
# print(stdDevOfLengths(['aaaaaaaaaaa', 'zaaaaaaaaaaa', 'paaaaaaaaaaaa']))
# print(stdDevOfLengths(['a', 'a', 'p']))

# print(stdDevOfLengths(['a', 'z', 'p']))
# print(stdDevOfLengths(['apples', 'oranges', 'kiwis', 'pineapples']))

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
		mu += len(l)
	mu = mu / len(L)

	for t in L:
		res += (len(t) - mu) ** 2
	res = (res / len(L))**0.5
	return res

# test cases
print(stdDevOfLengths(['a', 'za', 'paa']))
print(stdDevOfLengths(['aaaaaaaaaaa', 'zaaaaaaaaaaa', 'paaaaaaaaaaaa']))
print(stdDevOfLengths(['a', 'a', 'p']))

# print(stdDevOfLengths(['a', 'z', 'p']))
# print(stdDevOfLengths(['apples', 'oranges', 'kiwis', 'pineapples']))

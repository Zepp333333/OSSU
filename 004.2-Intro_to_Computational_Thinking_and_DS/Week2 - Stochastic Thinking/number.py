def checkN(n):
	new_n = str(n)[-1::] + str(n)[:-1:]

	return True if int(new_n) / n == 2 else False

n = 2
while not checkN(n):
	n *= 11
	print(n)


print(n)


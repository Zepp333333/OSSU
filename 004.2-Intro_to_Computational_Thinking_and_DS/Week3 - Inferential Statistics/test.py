s1 = [0, 1, 2, 3, 4, 5, 6]
s2 = [3, 3, 3, 3, 3, 3, 3]
s3 = [0, 0, 0, 3, 6, 6, 6]

S = {}
S[0] = [0, 1, 2, 3, 4, 5, 6]
S[1] = [3, 3, 3, 3, 3, 3, 3]
S[2] = [0, 0, 0, 3, 6, 6, 6]

m1 = sum(s1) / len(s1)
m2 = sum(s2) / len(s2)
m3 = sum(s3) / len(s3)

M = {}
M[0] = sum(S[0]) / len(S[0])
M[1] = sum(S[1]) / len(S[1])
M[2] = sum(S[2]) / len(S[2])

dev = 0
for s in range(3):
	dev = 0
	for i in range(len(S[s])):
		dev += (len(S[s]) - M[s]) ** 2

	print(dev)
# print(dev)



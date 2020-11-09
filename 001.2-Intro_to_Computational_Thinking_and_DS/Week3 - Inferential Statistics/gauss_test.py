import pylab
import random

dist = []
for i in range(1000000):
	dist.append(random.gauss(0, 30))
pylab.hist(dist, 10000)

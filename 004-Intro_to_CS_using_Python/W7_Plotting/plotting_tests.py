import pylab as plt

mySamples = []
myLinear = []
myQuadratic = []
myCubic = []
myExponential = []

for i in range(0, 30):
	mySamples.append(i)
	myLinear.append(i)
	myQuadratic.append(i ** 2)
	myCubic.append(i ** 3)
	myExponential.append(1.5 ** i)

# plt.interactive(False)

plt.figure('lin')
plt.subplot(221)
plt.xlabel('sample points')
plt.ylabel('linear function')
plt.ylim(0, 1000)
plt.title('linear')
plt.plot(mySamples, myLinear, 'b-', label='linear', linewidth=3.0)
plt.legend()
plt.legend(loc='upper left')
plt.ylim(0, 1000)

plt.subplot(223)
plt.plot('quad')
plt.plot(mySamples, myQuadratic)

plt.subplot(222)
plt.plot(mySamples, myCubic)

plt.subplot(224)

plt.yscale('log')
plt.plot(mySamples, myExponential)

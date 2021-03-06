import random

from matplotlib import pylab


class Location(object):
	def __init__(self, x, y):
		"""x and y are floats"""
		self.x = x
		self.y = y

	def move(self, deltaX, deltaY):
		"""deltaX and deltaY are floats"""
		return Location(self.x + deltaX, self.y + deltaY)

	def getX(self):
		return self.x

	def getY(self):
		return self.y

	def distFrom(self, other):
		ox = other.x
		oy = other.y
		xDist = self.x - ox
		yDist = self.y - oy
		return (xDist ** 2 + yDist ** 2) ** 0.5

	def __str__(self):
		return '<' + str(self.x) + ', ' + str(self.y) + '>'


class Field(object):
	def __init__(self):
		self.drunks = {}

	def addDrunk(self, drunk, loc):
		if drunk in self.drunks:
			raise ValueError('Duplicate drunk')
		else:
			self.drunks[drunk] = loc

	def getLoc(self, drunk):
		if drunk not in self.drunks:
			raise ValueError('Drunk not in field')
		return self.drunks[drunk]

	def moveDrunk(self, drunk):
		if drunk not in self.drunks:
			raise ValueError('Drunk not in field')
		xDist, yDist = drunk.takeStep()
		currentLocation = self.drunks[drunk]
		# use move methon of Location to get new location
		self.drunks[drunk] = currentLocation.move(xDist, yDist)


class Drunk(object):
	def __init__(self, name = None):
		"""Assumes name is a str"""
		self.name = name

	def __str__(self):
		return 'This drunk is named ' + self.name


class UsualDrunk(Drunk):
	def takeStep(self):
		stepChoices = [(0.0, 1.0), (0.0, -1.0), (1.0, 0.0), (-1.0, 0.0)]
		return random.choice(stepChoices)


class ColdDrunk(Drunk):
	def takeStep(self):
		stepChoices = [(0.0, 0.9), (0.0, -1.1), (1.0, 0.0), (-1.0, 0.0)]
		return random.choice(stepChoices)


def walk(f, d, numSteps):
	"""
	:param f: a Field
	:param d: a Drunk in f
	:param numSteps: an int >=0
	Moves d numSteps times;
	:return: the distance between the final location
			 and the location at the start of walk
	"""
	start = f.getLoc(d)
	for s in range(numSteps):
		f.moveDrunk(d)
	return start.distFrom(f.getLoc(d))


def simWalks(numSteps, numTrials, dClass):
	"""
	:param numSteps:  an int >= 0
	:param numTrials: an int > 0
	:param dClass: subclass of Drunk
	Simulates numTrials walks of numSteps steps each
	:return: list of the final distances for each trial
	"""
	Homer = dClass()
	origin = Location(0, 0)
	distances = []
	for t in range(numTrials):
		f = Field()
		f.addDrunk(Homer, origin)
		distances.append(round(walk(f, Homer, numSteps), 1))
	return distances

def drinkTest(walkLength, numTrials, dClass):
	"""
	:param walkLength: a sequence of ints >= 0
	:param numTrials: an int > 0
	:param dClass: a subclass of Drunk
	For each number of steps in walkLength, run simWalks with numTrials
	walks and prints results
	:return: none
	"""
	for numSteps in walkLength:
		distances = simWalks(numSteps, numTrials, dClass)
		print(dClass.__name__, 'random walk of', numSteps, 'steps')
		print(' Mean =', round(sum(distances)/len(distances), 4))
		print(' Max =', max(distances), 'min =', min(distances))


class styleIterator(object):
	def __init__(self, styles):
		self.index = 0
		self.styles = styles

	def nextStyle(self):
		result = self.styles[self.index]
		if self.index == len(self.styles) - 1:
			self.index = 0
		else:
			self.index += 1
		return result

def simDrunk(numTrials, dClass, walkLengths):
	meanDistances = []
	for numSteps in walkLengths:
		print('Starting simulation of', numSteps, 'steps')
		trials = simWalks(numSteps, numTrials, dClass)
		mean = sum(trials)/len(trials)
		meanDistances.append(mean)
	return meanDistances

def getFinalLocs(numSteps, numTrials, dClass):
	locs = []
	d = dClass()
	for t in range(numTrials):
		f = Field()
		f.addDrunk(d, Location(0,0))
		for s in range(numSteps):
			f.moveDrunk(d)
		locs.append(f.getLoc(d))
	return locs


def simAll(drunkKinds, walkLengths, numTrials):
	styleChoice = styleIterator(('m-', 'b--', 'g-.'))
	for dClass in drunkKinds:
		curStyle = styleChoice.nextStyle()
		print('Starting simulation of', dClass.__name__)
		means = simDrunk(numTrials, dClass, walkLengths)
		pylab.plot(walkLengths, means, curStyle, label = dClass.__name__)
		pylab.title('Mean Distance from Origin (' + str(numTrials) + ' trials)')
		pylab.xlabel('Number of Steps')
		pylab.ylabel('Distance from Origin')
		pylab.legend(loc = 'best')

def plotLocs(drunkKinds, numSteps, numTrials):
    styleChoice = styleIterator(('k+', 'r^', 'mo'))
    for dClass in drunkKinds:
        locs = getFinalLocs(numSteps, numTrials, dClass)
        xVals, yVals = [], []
        for loc in locs:
            xVals.append(loc.getX())
            yVals.append(loc.getY())
        xVals = pylab.array(xVals)
        yVals = pylab.array(yVals)
        meanX = sum(abs(xVals))/len(xVals)
        meanY = sum(abs(yVals))/len(yVals)
        curStyle = styleChoice.nextStyle()
        pylab.plot(xVals, yVals, curStyle,
                      label = dClass.__name__ +\
                      ' mean abs dist = <'
                      + str(meanX) + ', ' + str(meanY) + '>')
    pylab.title('Location at End of Walks ('
                + str(numSteps) + ' steps)')
    pylab.ylim(-1000, 1000)
    pylab.xlim(-1000, 1000)
    pylab.xlabel('Steps East/West of Origin')
    pylab.ylabel('Steps North/South of Origin')
    pylab.legend(loc = 'upper left')

class OddField(Field):
	def __init__(self, numHoles = 1000, xRange = 100, yRange = 100):
		Field.__init__(self)
		self.wormholes = {}
		for w in range(numHoles):
			x = random.randint(-xRange, xRange)
			y = random.randint(-yRange, yRange)
			newX = random.randint(-xRange, xRange)
			newY = random.randint(-yRange, yRange)
			newLoc = Location(newX, newY)
			self.wormholes[(x, y)] = newLoc

	def moveDrunk(self, drunk):
		Field.moveDrunk(self, drunk)
		x = self.drunks[drunk].getX()
		y = self.drunks[drunk].getY()
		if (x, y) in self.wormholes:
			self.drunks[drunk] = self.wormholes[(x, y)]

#TraceWalk using oddField
def traceWalk(fieldKinds, numSteps):
    styleChoice = styleIterator(('b+', 'r^', 'ko'))
    for fClass in fieldKinds:
        d = UsualDrunk()
        f = fClass()
        f.addDrunk(d, Location(0, 0))
        locs = []
        for s in range(numSteps):
            f.moveDrunk(d)
            locs.append(f.getLoc(d))
        xVals, yVals = [], []
        for loc in locs:
            xVals.append(loc.getX())
            yVals.append(loc.getY())
        curStyle = styleChoice.nextStyle()
        pylab.plot(xVals, yVals, curStyle,
                   label = fClass.__name__)
    pylab.title('Spots Visited on Walk ('
                + str(numSteps) + ' steps)')
    pylab.xlabel('Steps East/West of Origin')
    pylab.ylabel('Steps North/South of Origin')
    pylab.legend(loc = 'best')

traceWalk((Field, OddField), 500)

# random.seed(0)
# plotLocs((UsualDrunk, ColdDrunk), 10000, 1000)

# numSteps = (10, 100, 1000, 10000)
# simAll((UsualDrunk, ColdDrunk), numSteps, 100)



# def simAll(drunkKinds, walkLengths, numTrials):
# 	for dClass in drunkKinds:
# 		drinkTest(walkLengths, numTrials, dClass)

# random.seed(0)
# drinkTest((10, 1000, 1000, 10000), 100, UsualDrunk)

# random.seed(0)
# simAll((UsualDrunk, ColdDrunk), (1, 10, 100, 1000, 10000), 100)

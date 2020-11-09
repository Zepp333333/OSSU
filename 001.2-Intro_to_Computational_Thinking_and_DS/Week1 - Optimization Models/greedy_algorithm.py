import random
class Food(object):
	def __init__(self, n, v, w):
		self.name = n
		self.value = v
		self.calories = w

	def getValue(self):
		return self.value

	def getCost(self):
		return self.calories

	def density(self):
		return self.getValue() / self.getCost()

	def __str__(self):
		return self.name + ': <' + str(self.value) + ', ' + str(self.calories) + '>'


def buildMenu(names, values, calories):
	"""
	names, values, calories are lists of the same length
	:param names: list of strings
	:param values: list of numbers
	:param calories: list of numbers
	:return: list of Foods
	"""
	menu = []
	for i in range(len(values)):
		menu.append(Food(names[i], values[i], calories[i]))
	return menu


def greedy(items, maxCost, keyFunction):
	"""
	:param items: a list
	:param maxCost: >= 0
	:param keyFunction: maps element of items to numbers
	:return:
	"""
	itemsCopy = sorted(items, key=keyFunction, reverse=True)
	result = []
	totalValue, totalCost = 0.0, 0.0

	for i in range(len(itemsCopy)):
		if (totalCost + itemsCopy[i].getCost()) <= maxCost:
			result.append(itemsCopy[i])
			totalCost += itemsCopy[i].getCost()
			totalValue += itemsCopy[i].getValue()
	return (result, totalValue)


def testGreedy(items, constraint, keyFunction):
	taken, val = greedy(items, constraint, keyFunction)
	print('Total value of items taken = ', val)
	for item in taken:
		print('   ', item)

def testGreedys(foods, maxUnits):
	print('Use greedy by value to allocate ', maxUnits, ' calories')
	testGreedy(foods, maxUnits, Food.getValue)
	print('\nUse Greedy by cost to allocate ', maxUnits, ' calories')
	testGreedy(foods, maxUnits, lambda x: 1/Food.getCost(x))
	print('\nUse Greedy by cost by density ', maxUnits, ' calories')
	testGreedy(foods, maxUnits, Food.density)

def maxVal(toConsider, avail):
	"""
	:param toConsider: list of items
	:param avail: weight
	:return: tuple of the total value of a solution
	to 0/1 knapsack problem and the items of that solution
	"""
	if toConsider == [] or avail == 0:
		result = (0, ())
	elif toConsider[0].getCost() > avail:
		result = maxVal(toConsider[1:], avail)
	else:
		nextItem = toConsider[0]
		withVal, withToTake = maxVal((toConsider[1:]), avail - nextItem.getCost())
		withVal += nextItem.getValue()
		withoutVal, withoutToTake = maxVal(toConsider[1:], avail)
		if withVal > withoutVal:
			result = (withVal, withToTake + (nextItem,))
		else:
			result = (withoutVal, withoutToTake)
	return result

def fastMaxVal(toConsider, avail, memo = {}):
	"""
	:param toConsider: list of items
	:param avail: weight
	:memo: dict, key of memo is a tuple:
		- (items left to be considered, available weight)
		- items left ot be considered represented by len(toConsider)
	:return: tuple of the total value of a solution
	to 0/1 knapsack problem and the items of that solution
	"""
	if (len(toConsider), avail) in memo:
		result = memo[(len(toConsider), avail)]
	elif toConsider == [] or avail == 0:
		result = (0, ())
	elif toConsider[0].getCost() > avail:
		result = fastMaxVal(toConsider[1:], avail, memo)
	else:
		nextItem = toConsider[0]
		withVal, withToTake = fastMaxVal((toConsider[1:]), avail - nextItem.getCost(), memo)
		withVal += nextItem.getValue()
		withoutVal, withoutToTake = fastMaxVal(toConsider[1:], avail, memo)
		if withVal > withoutVal:
			result = (withVal, withToTake + (nextItem,))
		else:
			result = (withoutVal, withoutToTake)
	memo[(len(toConsider), avail)] = result
	return result

def testMaxVal(foods, maxUnits, algorithm, printItems = True):
	print('Menu contains ', len(foods), ' items')
	print('Use search tree to allocate ', maxUnits, ' calories')
	val, taken = algorithm(foods, maxUnits)
	if printItems:
		print('Total value of items taken = ', val)
		for item in taken:
			print('   ', item)

# names = ['wine', 'beer', 'pizza', 'burger', 'fries', 'cola', 'apple', 'donut', 'cake']
# values = [89,90,95, 100, 90, 79, 50, 10]
# calories = [123, 154, 258, 354, 365, 150, 95, 195]
# foods = buildMenu(names, values, calories)
#
# testGreedys(foods, 750)
# print('')
# testMaxVal(foods, 750)

def buildLargeMenu (numItems, maxVal, maxCost):
	items = []
	for i in range(numItems):
		items.append(Food(str(i), random.randint(1, maxVal),
		                  random.randint(1, maxCost)))
	return items

for numItems in (5, 10 , 15, 20 ,25, 30, 35, 40, 45, 512, 1024, 2048):
	items = buildLargeMenu(numItems, 90, 250)
	testMaxVal(items, 750, fastMaxVal, True)

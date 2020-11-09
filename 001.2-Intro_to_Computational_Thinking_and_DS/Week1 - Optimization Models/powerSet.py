import random
# generate all combination of N items
def powerSet(items):
	N = len(items)
	# enumerate the 2**N possible combinations
	for i in range(2**N):
		print()
		combo = []
		for j in range(N):

			# test bit jth of integer i
			#print('{:b}'.format(i)[::-1], '   ', j, '   ','{:b}'.format(i >> j), '   ', str((i >> j) % 2))

			if (i >> j) % 2 == 1:
				combo.append(items[j])
				print(i, '   ',  '{:b}'.format(i)[::-1], '   ', '{:b}'.format(i >> j)[::-1], '   ', j, '   ', combo)
		yield combo

# for i in powerSet([1, 2, 3]):
# 	#print(i)
# 	pass

def yieldAllCombos(items):
	"""
	  Generates all combinations of N items into two bags, whereby each
	  item is in one or zero bags.

	  Yields a tuple, (bag1, bag2), where each bag is represented as
	  a list of which item(s) are in each bag.
	"""
	N = len(items)
	for i in range(3**N):
		a, b = [], []
		for item in items:
			i, k = divmod(i, 3)
			if k == 0:
				pass
			elif k == 1:
				a.append(item)
			elif k == 2:
				b.append(item)
		yield (a, b)



## somebodys solution for multiple bags - very beautiful
def powerSets(items, n_bags=2):
    for i in range(n_bags**len(items)):
        # dynamically generate empty bags for this iteration
        bags = [[] for _ in range(n_bags)]

        for item in items:
            # Determine in which bag each item should go
            i, bag = divmod(i, n_bags)

            # Add item to that bag
            bags[bag].append(item)

        # Yield as tuple with the 0-bag ("no bag") removed
        yield tuple(bags[1:])


class Item(object):
    def __init__(self, n, v, w):
        self.name = n
        self.value = float(v)
        self.weight = float(w)
    def getName(self):
        return self.name
    def getValue(self):
        return self.value
    def getWeight(self):
        return self.weight
    def __str__(self):
        return '<' + self.name + ', ' + str(self.value) + ', '\
                     + str(self.weight) + '>'

def buildItems():
    return [Item(n,v,w) for n,v,w in (('clock', 175, 10),
                                      ('painting', 90, 9),
                                      ('radio', 20, 4),
                                      ('vase', 50, 2),
                                      ('book', 10, 1),
                                      ('computer', 200, 20))]

# for a, b in yieldAllCombos([1,2,3]):
# 	print(a, '   ', b)
# 	pass



items = buildItems()

# for a, b in powerSets(items):
# 	print(a, b)

for a, b in yieldAllCombos(items):
	print(a, '   ', b, '\n')
	pass
# for item in items:
# 	print(item)




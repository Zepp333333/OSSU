import random




def noReplacementSimulation(numTrials):
	'''
	Runs numTrials trials of a Monte Carlo simulation
	of drawing 3 balls out of a bucket containing
	3 red and 3 green balls. Balls are not replaced once
	drawn. Returns the a decimal - the fraction of times 3
	balls of the same color were drawn.
	'''

	result = {'success':0, 'fail':0 }

	for i in range(numTrials):
		#create bucket with 6 balls
		bucket = ['r', 'r', 'r', 'g', 'g', 'g']
		draw = {'r':0, 'g':0}

		#Draw 3 balls and record results
		for i in range(3):
			choice = random.choice(bucket)
			draw[choice] += 1
			bucket.remove(choice)

		#check if we succeeded drawing 3 balls of same collor
		# and record the result
		if draw['r'] == 3 or draw['g'] == 3:
			result['success'] += 1
		else:
			result['fail'] += 1

	return result['success'] / (result['success'] + result['fail'])


print(noReplacementSimulation(100000))

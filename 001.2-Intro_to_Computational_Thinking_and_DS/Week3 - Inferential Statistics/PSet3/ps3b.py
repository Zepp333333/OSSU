# Problem Set 3: Simulating the Spread of Disease and Virus Population Dynamics 

import random
import pylab

import os
os.environ["OPENBLAS_NUM_THREADS"] = "1"
import numpy as np
#from ps3b_precompiled_37 import *




''' 
#Begin helper code
'''

class NoChildException(Exception):
	"""
	NoChildException is raised by the reproduce() method in the SimpleVirus
	and ResistantVirus classes to indicate that a virus particle does not
	reproduce. You can use NoChildException as is, you do not need to
	modify/add any code.
	"""
	pass
'''
#End helper code
'''


#
# PROBLEM 1
#
class SimpleVirus(object):

	"""
	Representation of a simple virus (does not model drug effects/resistance).
	"""
	def __init__(self, maxBirthProb, clearProb):
		"""
		Initialize a SimpleVirus instance, saves all parameters as attributes
		of the instance.
		maxBirthProb: Maximum reproduction probability (a float between 0-1)
		clearProb: Maximum clearance probability (a float between 0-1).
		"""

		self.maxBirthprob = maxBirthProb
		self.clearProb = clearProb

	def getMaxBirthProb(self):
		"""
		Returns the max birth probability.
		"""

		return self.maxBirthprob

	def getClearProb(self):
		"""
		Returns the clear probability.
		"""

		return self.clearProb

	def doesClear(self):
		""" Stochastically determines whether this virus particle is cleared from the
		patient's body at a time step.
		returns: True with probability self.getClearProb and otherwise returns
		False.
		"""

		return random.random() < self.getClearProb()


	def reproduce(self, popDensity):
		"""
		Stochastically determines whether this virus particle reproduces at a
		time step. Called by the update() method in the Patient and
		TreatedPatient classes. The virus particle reproduces with probability
		self.maxBirthProb * (1 - popDensity).

		If this virus particle reproduces, then reproduce() creates and returns
		the instance of the offspring SimpleVirus (which has the same
		maxBirthProb and clearProb values as its parent).

		popDensity: the population density (a float), defined as the current
		virus population divided by the maximum population.

		returns: a new instance of the SimpleVirus class representing the
		offspring of this virus particle. The child should have the same
		maxBirthProb and clearProb values as this virus. Raises a
		NoChildException if this virus particle does not reproduce.
		"""

		if random.random() < (self.getMaxBirthProb() * (1 - popDensity)):
			# return new instance
			return SimpleVirus(self.getMaxBirthProb(), self.getClearProb())
		else:
			raise NoChildException()


class Patient(object):
	"""
	Representation of a simplified patient. The patient does not take any drugs
	and his/her virus populations have no drug resistance.
	"""

	def __init__(self, viruses, maxPop):
		"""
		Initialization function, saves the viruses and maxPop parameters as
		attributes.

		viruses: the list representing the virus population (a list of
		SimpleVirus instances)

		maxPop: the maximum virus population for this patient (an integer)
		"""

		self.viruses = viruses
		self.maxPop = maxPop

	def getViruses(self):
		"""
		Returns the viruses in this Patient.
		"""

		return self.viruses


	def getMaxPop(self):
		"""
		Returns the max population.
		"""

		return self.maxPop


	def getTotalPop(self):
		"""
		Gets the size of the current total virus population.
		returns: The total virus population (an integer)
		"""

		return int(len(self.viruses))


	def update(self):
		"""
		Update the state of the virus population in this patient for a single
		time step. update() should execute the following steps in this order:

		- Determine whether each virus particle survives and updates the list
		of virus particles accordingly.

		- The current population density is calculated. This population density
		  value is used until the next call to update()

		- Based on this value of population density, determine whether each
		  virus particle should reproduce and add offspring virus particles to
		  the list of viruses in this patient.

		returns: The total virus population at the end of the update (an
		integer)
		"""

		# - Determine whether each virus particle survives and updates the list
		# of virus particles accordingly.
		survived_viruses = []
		for virus in self.viruses:
			if not virus.doesClear():
				survived_viruses.append(virus)
		self.viruses = list(survived_viruses)

		# Current population density is calculated. Used until the next call to update()
		popDensity = self.getTotalPop() / self.getMaxPop()

		# Based on popDensity, determine whether each particle should reproduce
		# and add offspring virus particles to the list of viruses in this patient.
		new_viruses = []
		for virus in self.viruses:
			try:
				new_viruses.append(virus.reproduce(popDensity))
			except NoChildException:
				pass
		self.viruses = self.viruses + new_viruses

		return self.getTotalPop()   # int: total virus population at the end of the update


### Test code for SimpleVirus
# v = SimpleVirus(1, 0)
# print(v.getMaxBirthProb(), v.getClearProb())
# y = v.reproduce(0.5);
# print(y)

### Test code for Patient
# v = SimpleVirus(1, 0)
# v2 = SimpleVirus(0, 1)
# l = [v, v2]
# p = Patient(l, 1000)
# # for virus in p.getViruses():
# # 	print(virus.getClearProb())
#
# for i in range(10):
# 	print(p.update())
# print(p.update())


#
# PROBLEM 2
#
def simulationWithoutDrug(numViruses, maxPop, maxBirthProb, clearProb,
                          numTrials):
	"""
	Run the simulation and plot the graph for problem 3 (no drugs are used,
	viruses do not have any drug resistance).
	For each of numTrials trial, instantiates a patient, runs a simulation
	for 300 timesteps, and plots the average virus population size as a
	function of time.

	numViruses: number of SimpleVirus to create for patient (an integer)
	maxPop: maximum virus population for patient (an integer)
	maxBirthProb: Maximum reproduction probability (a float between 0-1)
	clearProb: Maximum clearance probability (a float between 0-1)
	numTrials: number of simulation runs to execute (an integer)
	"""

	TIMESTEPS = 300

	# initialize list of NumViruses viruses
	viruses = []
	for i in range(numViruses):
		viruses.append(SimpleVirus(maxBirthProb, clearProb))

	#initialize patient with viruses
	patient = Patient(viruses, maxPop)

	#initialize results ndarray
	results = np.zeros((TIMESTEPS, numTrials))

	for i in range(numTrials):
		for t in range(TIMESTEPS):
			results[t][i] = patient.update()

	#prepare output list
	output = []
	for i in range(len(results)):
		output.append(np.mean(results[i]))

	#plot
	pylab.plot(output, label="SimpleVirus")
	pylab.title("SimpleVirus simulation")
	pylab.xlabel("Time Steps")
	pylab.ylabel("Average Virus Population")
	pylab.legend(loc="best")
	pylab.show()

### Test code for simulationWithoutDrug
# simulationWithoutDrug(100, 1000, 0.1, 0.05, 10)


# PROBLEM 3
class ResistantVirus(SimpleVirus):
	"""
	Representation of a virus which can have drug resistance.
	"""

	def __init__(self, maxBirthProb, clearProb, resistances, mutProb):
		"""
		Initialize a ResistantVirus instance, saves all parameters as attributes
		of the instance.

		maxBirthProb: Maximum reproduction probability (a float between 0-1)

		clearProb: Maximum clearance probability (a float between 0-1).

		resistances: A dictionary of drug names (strings) mapping to the state
		of this virus particle's resistance (either True or False) to each drug.
		e.g. {'guttagonol':False, 'srinol':False}, means that this virus
		particle is resistant to neither guttagonol nor srinol.

		mutProb: Mutation probability for this virus particle (a float). This is
		the probability of the offspring acquiring or losing resistance to a drug.
		"""
		SimpleVirus.__init__(self, maxBirthProb, clearProb)
		self.maxBirthprob = maxBirthProb
		self.clearProb = clearProb
		self.resistances = resistances
		self.mutProb = mutProb


	def getResistances(self):
		"""
		Returns the resistances for this virus.
		"""
		return self.resistances

	def getMutProb(self):
		"""
		Returns the mutation probability for this virus.
		"""
		return self.mutProb

	def isResistantTo(self, drug):
		"""
		Get the state of this virus particle's resistance to a drug. This method
		is called by getResistPop() in TreatedPatient to determine how many virus
		particles have resistance to a drug.

		drug: The drug (a string)

		returns: True if this virus instance is resistant to the drug, False
		otherwise.
		"""

		return self.resistances[drug] if drug in self.resistances else False


	def reproduce(self, popDensity, activeDrugs):
		"""
		Stochastically determines whether this virus particle reproduces at a
		time step. Called by the update() method in the TreatedPatient class.

		A virus particle will only reproduce if it is resistant to ALL the drugs
		in the activeDrugs list. For example, if there are 2 drugs in the
		activeDrugs list, and the virus particle is resistant to 1 or no drugs,
		then it will NOT reproduce.

		Hence, if the virus is resistant to all drugs
		in activeDrugs, then the virus reproduces with probability:

		self.maxBirthProb * (1 - popDensity).

		If this virus particle reproduces, then reproduce() creates and returns
		the instance of the offspring ResistantVirus (which has the same
		maxBirthProb and clearProb values as its parent). The offspring virus
		will have the same maxBirthProb, clearProb, and mutProb as the parent.

		For each drug resistance trait of the virus (i.e. each key of
		self.resistances), the offspring has probability 1-mutProb of
		inheriting that resistance trait from the parent, and probability
		mutProb of switching that resistance trait in the offspring.

		For example, if a virus particle is resistant to guttagonol but not
		srinol, and self.mutProb is 0.1, then there is a 10% chance that
		that the offspring will lose resistance to guttagonol and a 90%
		chance that the offspring will be resistant to guttagonol.
		There is also a 10% chance that the offspring will gain resistance to
		srinol and a 90% chance that the offspring will not be resistant to
		srinol.

		popDensity: the population density (a float), defined as the current
		virus population divided by the maximum population

		activeDrugs: a list of the drug names acting on this virus particle
		(a list of strings).

		returns: a new instance of the ResistantVirus class representing the
		offspring of this virus particle. The child should have the same
		maxBirthProb and clearProb values as this virus. Raises a
		NoChildException if this virus particle does not reproduce.
		"""

		#check if virus is resistand to all drugs in the activeDrugs
		resistant = True
		for drug in activeDrugs:
			resistant = resistant & self.isResistantTo(drug)

		#raise exception if not resistant and therefore will not reproduce
		if not resistant:
			raise NoChildException

		# Randomly check if this particle is going to be reproduced
		if random.random() < (self.getMaxBirthProb() * (1 - popDensity)):
			# set the mutations and return new instance
			offspring_resistances = {}
			for r in self.resistances:
				if self.resistances[r]:
					offspring_resistances[r] = random.random() < (1 - self.mutProb)
				else:
					offspring_resistances[r] = random.random() < self.mutProb
			return ResistantVirus(self.getMaxBirthProb(), self.getClearProb(), offspring_resistances, self.mutProb)
		else:
			raise NoChildException()

# Test code for ResistantVirus
# resistances = {'drug1':False, 'drug2':True, 'drug3':True, 'drug4':False}
# # v = ResistantVirus(1, 0.05, resistances, 0.5)
# activeDrugs = ['drug1', 'drug2', 'drug3']
# # # print(v.getMaxBirthProb(), v.getClearProb(), v.getResistances(), v.getMutProb())
# # # print(v.isResistantTo('drug2'))
# # y = v.reproduce(0, activeDrugs);
# # print(y.getResistances())
#
# virus = ResistantVirus(0.0, 1.0, {"drug1":True, "drug2":False}, 0.0)
# virus.reproduce(0, [])


class TreatedPatient(Patient):
	"""
	Representation of a patient. The patient is able to take drugs and his/her
	virus population can acquire resistance to the drugs he/she takes.
	"""

	def __init__(self, viruses, maxPop):
		"""
		Initialization function, saves the viruses and maxPop parameters as
		attributes. Also initializes the list of drugs being administered
		(which should initially include no drugs).

		viruses: The list representing the virus population (a list of
		virus instances)

		maxPop: The  maximum virus population for this patient (an integer)
		"""

		Patient.__init__(self, viruses, maxPop)
		self.viruses = viruses
		self.maxPop = maxPop
		self.listOfDrugs = []


	def addPrescription(self, newDrug):
		"""
		Administer a drug to this patient. After a prescription is added, the
		drug acts on the virus population for all subsequent time steps. If the
		newDrug is already prescribed to this patient, the method has no effect.

		newDrug: The name of the drug to administer to the patient (a string).

		postcondition: The list of drugs being administered to a patient is updated
		"""

		if newDrug not in self.listOfDrugs:
			self.listOfDrugs.append(newDrug)


	def getPrescriptions(self):
		"""
		Returns the drugs that are being administered to this patient.

		returns: The list of drug names (strings) being administered to this
		patient.
		"""

		return self.listOfDrugs


	def getResistPop(self, drugResist):
		"""
		Get the population of virus particles resistant to the drugs listed in
		drugResist.

		drugResist: Which drug resistances to include in the population (a list
		of strings - e.g. ['guttagonol'] or ['guttagonol', 'srinol'])

		returns: The population of viruses (an integer) with resistances to all
		drugs in the drugResist list.
		"""

		population = 0

		for virus in self.viruses:
			# produce dict of true drug resistances of a virus
			true_resistances = {}
			for (key, value) in virus.getResistances().items():
				if value:
					true_resistances[key] = value
			# check if drugResist is a subset of true resistance. increment resistant population if true
			if set(drugResist).issubset(true_resistances):
				population += 1
		return population


	def update(self):
		"""
		Update the state of the virus population in this patient for a single
		time step. update() should execute these actions in order:

		- Determine whether each virus particle survives and update the list of
		  virus particles accordingly

		- The current population density is calculated. This population density
		  value is used until the next call to update().

		- Based on this value of population density, determine whether each
		  virus particle should reproduce and add offspring virus particles to
		  the list of viruses in this patient.
		  The list of drugs being administered should be accounted for in the
		  determination of whether each virus particle reproduces.

		returns: The total virus population at the end of the update (an
		integer)
		"""

		# - Determine whether each virus particle survives and updates the list
		# of virus particles accordingly.
		survived_viruses = []
		for virus in self.viruses:
			if not virus.doesClear():
				survived_viruses.append(virus)
		self.viruses = list(survived_viruses)

		# Current population density is calculated. Used until the next call to update()
		popDensity = self.getTotalPop() / self.getMaxPop()

		# Based on popDensity, determine whether each particle should reproduce
		# and add offspring virus particles to the list of viruses in this patient.
		new_viruses = []
		for virus in self.viruses:
			try:
				new_viruses.append(virus.reproduce(popDensity, self.listOfDrugs))
			except NoChildException:
				pass
		self.viruses = self.viruses + new_viruses

		return self.getTotalPop()  # int: total virus population at the end of the update


# ### Test code for TreatedPatient
#
#
# # virus1_getResistances = {'drug1': True, 'drug2': False}
# # virus2_getResistances = {'drug1': False, 'drug2': True}
# # virus3_getResistances = {'drug1': False, 'drug2': False}
# # virus4_getResistances = {'drug1': True, 'drug2': True}
#
# v1 = ResistantVirus(0.8, 0.0, {"drug1":True, "drug2":False}, 0.0)
# v2 = ResistantVirus(0.6, 0.0, {"drug1":True, "drug2":True}, 0.0)
# v3 = ResistantVirus(0.5, 0.0, {"drug1":True, "drug2":True, 'drug3': True}, 0.0)
# LoV = [v1, v2, v3]
#
# p = TreatedPatient(LoV, 10)
#
# dr1 = []
# dr2 = ['drug1']
# dr3 = ['drug2']
# dr4 = ['drug1', 'drug2']
# dr5 = ['drug1', 'drug2', 'drug3']
# Lodr = [dr1, dr2, dr3, dr4, dr5]
#
# print(p.getResistPop(dr4))
# for i in range(5):
# 	print(p.update())



#resistances1 = {'drug1':False, 'drug2':True, 'drug3':True, 'drug4':False}
# # v = ResistantVirus(1, 0.05, resistances, 0.5)
# activeDrugs = ['drug1', 'drug2', 'drug3']




# v = SimpleVirus(1, 0)
# v2 = SimpleVirus(0, 1)
# l = [v, v2]
# p = Patient(l, 1000)
# for virus in p.getViruses():
# 	print(virus.getClearProb())

# for i in range(10):
# 	print(p.update())
# print(p.update())




# LoV = [virus1_getResistances]
# LoV = [virus1_getResistances, virus2_getResistances, virus3_getResistances, virus4_getResistances]




#
# PROBLEM 4
#

def simulationWithDrug(numViruses, maxPop, maxBirthProb, clearProb, resistances,
                       mutProb, numTrials):
	"""
	Runs simulations and plots graphs for problem 5.

	For each of numTrials trials, instantiates a patient, runs a simulation for
	150 timesteps, adds guttagonol, and runs the simulation for an additional
	150 timesteps.  At the end plots the average virus population size
	(for both the total virus population and the guttagonol-resistant virus
	population) as a function of time.

	numViruses: number of ResistantVirus to create for patient (an integer)
	maxPop: maximum virus population for patient (an integer)
	maxBirthProb: Maximum reproduction probability (a float between 0-1)
	clearProb: maximum clearance probability (a float between 0-1)
	resistances: a dictionary of drugs that each ResistantVirus is resistant to
				 (e.g., {'guttagonol': False})
	mutProb: mutation probability for each ResistantVirus particle
			 (a float between 0-1).
	numTrials: number of simulation runs to execute (an integer)

	"""

	TIMESTEPS = 300

	# initialize list of NumViruses viruses
	viruses = []
	for i in range(numViruses):
		viruses.append(ResistantVirus(maxBirthProb, clearProb, resistances, mutProb))

	# initialize patient with viruses
	patient = TreatedPatient(viruses, maxPop)

	# initialize results ndarray
	population = np.zeros((TIMESTEPS, numTrials))
	resistPop = np.zeros((TIMESTEPS, numTrials))

	for i in range(0, numTrials, 2):
		for t in range(TIMESTEPS):
			# introduce drug at step 150
			if t == 150:
				patient.addPrescription('guttagonol')
			population[t][i] = patient.update()
			resistPop[t][i] = patient.getResistPop(resistances)

	# prepare output lists
	out_pop = []
	out_resist = []
	for i in range(len(population)):
		out_pop.append(np.mean(population[i]))
		out_resist.append(np.mean(resistPop[i]))


	# plot
	pylab.plot(out_pop, label="Total Virus Population")
	pylab.plot(out_resist, label="ResistantVirus")
	pylab.title("ResistantVirus simulation")
	pylab.xlabel("time steps")
	pylab.ylabel("# viruses")
	pylab.legend(loc="best")
	pylab.show()



### Test code for simulationWithDrug
#from ps3b_precompiled_37 import *
# simulationWithDrug(100, 1000, 0.1, 0.05, {'guttagonol': False}, 0.005, 10)
# simulationWithDrug(1, 10, 1.0, 0.0, {}, 1.0, 5)
# simulationWithDrug(1, 20, 1.0, 0.0, {"guttagonol": True}, 1.0, 5)
simulationWithDrug(75, 100, .8, 0.1, {"guttagonol": True}, 0.8, 1)

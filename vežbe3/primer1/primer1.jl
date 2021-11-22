# primer 1

include("algorithm.jl")

numberOfParticles = 10
numberOfOperands = 5	# n
minRang = 100
maxRang = 200
targetValue = 200			# s
maxIteration = 2000
maxVelocity = 10

swarm = generateSwarm(numberOfParticles, numberOfOperands, minRang, maxRang)
PsoAlgorithm!(swarm, targetValue, maxIteration, maxVelocity)

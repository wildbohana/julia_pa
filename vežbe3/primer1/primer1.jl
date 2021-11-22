# primer 1

include("algorithm.jl")

numberOfParticles = 10
numberOfOperands = 5
minRang = 100
maxRang = 200
targetValue = 200	
maxIteration = 2000
maxVelocity = 10

swarm = generateSwarm(numberOfParticles, numberOfOperands, minRang, maxRang)
PsoAlgorithm!(swarm, targetValue, maxIteration, maxVelocity)

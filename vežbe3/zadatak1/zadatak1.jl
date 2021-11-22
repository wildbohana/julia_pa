# zadatak 1

include("algorithm.jl")

numberOfParticles = 10
numberOfOperands = 6 
minRang = -1
maxRang = 1
targetValue = 0 
maxIteration = 2000
maxVelocity = 0.2

swarm = generateSwarm(numberOfParticles, numberOfOperands, minRang, maxRang)
PsoAlgorithm!(swarm, targetValue, maxIteration, maxVelocity)

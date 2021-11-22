include("geneticAlgorithm.jl")

genesLength = 6
populationSize = 50

repeatSize = 3
crossoverPoint = 3
mutationPercentage = 0.2
elitePercentage = 0.2


population = generatePopulation(populationSize, genesLength)
calculatePopulationFitness!(population)
printPopulation(population)
popGen, repeatCount, population = geneticAlgorithm!(population, elitePercentage, crossoverPoint, mutationPercentage, repeatSize)
printPopulation(population)
print("\nUkupan broj generacija je $popGen\n")
print("Broj ponavljanja poslednjeg najboljeg fitness-a je $repeatCount\n")

# primer 1

include("population.jl")

function geneticAlgorithm!(data, fitValue, selectionSize, crossoverPoint, mutationPercentage, repeatSize) 
    calculatePopulationFitness!(data, fitValue)
    bestFit = data[1].fitness

    repeatCount = 1
    popGen = 0

    while (data[1].fitness > 0) && (repeatCount < repeatSize)
        data = selectPopulation(data, selectionSize)
        data = crossoverPopulation(data, crossoverPoint)
        mutatePopulation!(data, mutationPercentage)
        calculatePopulationFitness!(data, fitValue)
		
	popGen += 1
        print("Generacija $popGen, bestFit $bestFit, broj ponavljanja $repeatCount ")
        
	if bestFit == data[1].fitness
            repeatCount += 1
        else
            bestFit = data[1].fitness
            repeatCount = 1
        end

        
    end
    return popGen, repeatCount, population
end

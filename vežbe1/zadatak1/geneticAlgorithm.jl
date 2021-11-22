# zadatak 1

include("population.jl")

function geneticAlgorithm!(data, elitePercentage, crossoverPoint, mutationPercentage, repeatSize) 
    calculatePopulationFitness!(data)
    bestFit = data[1].fitness
    repeatCount = 1
    popGen = 0

    populationSize = length(data)
    eliteSize = Int(trunc(elitePercentage * populationSize))

	eliteSize = eliteSize + (populationSize - eliteSize) % 2


    while (data[1].fitness > 0) && (repeatCount < repeatSize)
        elite = deepcopy(selectPopulation(data, eliteSize))
        data = selectPopulation(data, populationSize-eliteSize)
        data = crossoverPopulation(data, crossoverPoint)
        mutatePopulation!(data, mutationPercentage)
        data = [data; elite]
        calculatePopulationFitness!(data)
        
		popGen += 1
		println("Generacija $popGen bestFit $bestFit broj ponavljanja $repeatNum")

        if abs(bestFit - data[1].fitness) < 0.01
            repeatCount += 1
        else
            bestFit = data[1].fitness
            repeatCount = 1
        end

        popGen = popGen + 1
    end

    return popGen, repeatCount, data
end

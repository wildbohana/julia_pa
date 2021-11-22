# zadatak 2

include("population.jl")

function converge(bestFits)
    len = length(bestFits)
    if bestFits[len] < 0.01
        return true
    elseif len < 3
        return false
    elseif bestFits[len - 2] == bestFits[len]				# tri uzastopna ponavljanja istog rešenja, uslov zasićenja
        return true
    else
        return false
    end
end

function geneticAlgorithm!(data, elitePercentage, crossoverPoint1, crossoverPoint2, mutationPercentage, values, weights, maxCapacity)
    calculatePopulationFitness!(data, values, weights, maxCapacity)
    populationSize = length(data)
    eliteSize = Int(trunc(populationSize * elitePercentage))

    # Ako je broj jedinki elite neparan, dodaj jos jednu jedinku do parnog broja
    eliteSize = eliteSize + (populationSize - eliteSize) % 2
    # JEBO MAMU SVOJU ZAŠTO NIKO NIJE REKAO DA POPULATIONSIZE MORA BITI PARAN BROJ DA BI POLA KODA KURCU VALJALO?

    bestFits = [data[1].fitness]

    while !converge(bestFits)
        elite = deepcopy(selectPopulation(data, eliteSize))
        data = selectPopulation(data, populationSize - eliteSize)
        data = crossoverPopulation!(data, crossoverPoint1, crossoverPoint2)
        mutatePopulation!(data, mutationPercentage)
        data = [data; elite]
        calculatePopulationFitness!(data, values, weights, maxCapacity)
        bestFits = [bestFits; data[1].fitness]
    end
    return length(bestFits), data
end

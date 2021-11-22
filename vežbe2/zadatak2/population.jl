# zadatak 2

include("entity.jl")

function generatePopulation(n, genesLength)						# populationSize, numberOfRocks
    data = []
    for i in 1:n
        entity = generateEntity(genesLength)
        push!(data, entity)
    end
    return data
end

function printPopulation(data)
    for i in 1:length(data)
        printEntity(data[i])
    end
end

function calculatePopulationFitness!(data, values, weights, maxCapacity)
    for i in 1:length(data)
        calculateFitness!(data[i], values, weights, maxCapacity)
    end
    sort!(data, by = d -> d.fitness, rev = false)
end

function crossoverPopulation!(data, crossoverPoint1, crossoverPoint2)
    newData = []
    for i in 1:2:length(data)
        entity1 = deepcopy(data[i])
        entity2 = deepcopy(data[i + 1])
        crossover!(entity1, entity2, crossoverPoint1, crossoverPoint2)
        push!(newData, entity1)
        push!(newData, entity2)
    end
    return newData
end

function mutatePopulation!(data, mutationPercentage)
    for i in 1:length(data)
        mutate!(data[i], mutationPercentage)
    end
end

function selectPopulation(data, n)
    return copy(data[1:n])
end

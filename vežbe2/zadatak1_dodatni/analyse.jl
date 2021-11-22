include("geneticAlgorithm.jl")

function calculateAverage(data, elitePercentage, crossoverPoint, mutationPercentage, num)
    averageGen = 0.0
    averageFit = 0.0
    for i in 1:num											# num -> broj iteracija
        gen, pop = geneticAlgorithm!(data, elitePercentage, crossoverPoint, mutationPercentage)
        averageGen += gen
        averageFit += pop[1].fitness
    end
    averageGen /= num
    averageFit /= num

    return averageGen, averageFit
end

function findBestElitePercentage(data, eliteRange, crossoverPoint, mutationPercentage, num)
    resultsFit = []
    resultsGen = []
    for elitePercentage in eliteRange						# 0, 0.01, 0.02, 0.03, ..., 0.29, 0.3
        dataCopy = deepcopy(data)
        averageGen, averageFit = calculateAverage(dataCopy, elitePercentage, crossoverPoint, mutationPercentage, num)
        push!(resultsFit, averageFit)
        push!(resultsGen, averageGen)
    end
    minIndex = argmin(resultsFit)							# traži indeks generacije sa najmanjim fitnessom
    optimalValue = resultsFit[minIndex]						# i ovako izvlačimo vrednog tog najmanjeg fitnessa
    return minIndex, optimalValue, resultsFit, resultsGen
end

function findBestCrossoverAndMutation(data, elitePercentage, crossoverRange, mutationRange, num)
    resultsFit = ones(length(crossoverRange), length(mutationRange))
    resultsGen = ones(length(crossoverRange), length(mutationRange))

    for i in 1:length(crossoverRange)
        crossoverPoint = crossoverRange[i]					# crossoverPoint je 2, 3, 4, 5

        for j in 1:length(mutationRange)					# 0, 0.01, ..., 0.3 -> koliko su učestale mutacije
            mutationPercentage = mutationRange[j]			# change: mutationPoint -> mutationPercentage    !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
            dataCopy = deepcopy(data)
            averageGen, averageFit = calculateAverage(dataCopy, elitePercentage, crossoverPoint, mutationPercentage, num)
            resultsFit[i, j] = averageFit
            resultsGen[i, j] = averageGen
        end
    end
    coordinates = argmin(resultsFit)						# vratiće niz koordinata i,j na kojima se nalazi resultsFit sa najmanjim fitnessom
    minCrossoverIndex = coordinates[1]						# prva koordinata je tačka za crossover (for j in 1:length(mutationRange))
    minMutationIndex = coordinates[2]						# druga koordinata je tačka do koje geni jedinke mutiraju (for j in 1:length(mutationRange))
    optimalValue = resultsFit[minCrossoverIndex, minMutationIndex]
															# i samo kopiraš vrednost fitnessa koji se nalazi na tim koordinatama
    return minCrossoverIndex, minMutationIndex, optimalValue, resultsFit, resultsGen
end

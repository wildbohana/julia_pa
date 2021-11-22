# zadatak 2

mutable struct Entity
    genes::Array{Int64, 1}
    fitness::Int64
end

function generateEntity(genesLength)
    return Entity(rand(0:1, genesLength), 0)
end

function printEntity(entity)
    for i in 1:length(entity.genes)
        print(entity.genes[i])
    end
    println(entity.fitness)
end

function calculateFitness!(entity, values, weights, maxCapacity)
    selectedWeights = weights[entity.genes .== 1]
    sumSelectedWeights = sum(selectedWeights)
    if sumSelectedWeights > maxCapacity
        entity.fitness = sum(values)
		# fitness stavi na najveći mogući tako što ćeš sabrati APSOLUTNO SVE VREDNOSTI
    else
        notSelectedValues = values[entity.genes .== 0]
        entity.fitness = sum(notSelectedValues)	
		# u suprotnom saberi neizabrano kamenje (tj izaberi to kamenje kao rešenje)
		# u prevodu, recimo da je maksimalna suma kamenja 100, i ti ako sabereš sva neizabrano kamenje, ti ćeš imati vrednost 4, a možeš imati i 40 - bolja vrednost je 4 jer je bliža maksimumu sume (tj više vrednosti si natrpala)
    end
end

function crossover!(entity1, entity2, crossoverPoint1, crossoverPoint2)
    for i in (crossoverPoint1 + 1):crossoverPoint2				# crossover od tačke(+1) do tačke, a ne od tačke do kraja
        x = entity1.genes[i]
        entity1.genes[i] = entity2.genes[i]
        entity2.genes[i] = x
    end
end

function mutate!(entity, mutationPercentage)
    if rand(Float64) < mutationPercentage
        mutationPoint = rand(1:length(entity.genes))
        entity.genes[mutationPoint] = 1 - entity.genes[mutationPoint]
    end
end

# primer 1

mutable struct Entity
    genes::Array{Int64, 1}
    fitness::Int64
end

function generateEntity(genesLength)
    return Entity(rand(0:1,genesLength),0)
end

function calculateFitness!(entity, fitValue)
    entity.fitness = 0
    for i in 1:length(entity.genes)
        entity.fitness += entity.genes[i]
    end
    entity.fitness = abs(entity.fitness - fitValue)
end

function crossover!(entity1, entity2, crossoverPoint)
    for i in 1:crossoverPoint
        x = entity1.genes[i]
        entity1.genes[i] = entity2.genes[i]
        entity2.genes[i] = x
    end
end

function mutation!(entity, mutationPercentage)
    if rand(Float64) < mutationPercentage
        mutationPoint = rand(1:length(entity.genes))
        entity.genes[mutationPoint] = 1 - entity.genes[mutationPoint]
	# invertovanje po matematički
    end
end

function printEntity(entity)
    for i in 1:length(entity.genes)
        print(entity.genes[i])
    end
    print(" $(entity.fitness)\n")
end

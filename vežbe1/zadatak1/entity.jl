# zadatak 1

mutable struct Entity
    genes::Array{Float64, 1}
    fitness::Float64
end

function generateEntity(genesLength)
    return Entity(rand(-1.0:0.0001:1.0, genesLength), 0)
end

function calculateFitness!(entity1)
    x = entity1.genes[1]
    y = entity1.genes[2]
    z = entity1.genes[3]
    w = entity1.genes[4]
    u = entity1.genes[5]
    v = entity1.genes[6]

    entity1.fitness = abs(4*x^2 - 6*x - 3*y^3 + 0.5*y + 3*z + 8*w - 6.1*u + 2*v - 10)
end

function crossover!(entity1, entity2, crossoverPoint)
    for i in 1:crossoverPoint
        x = entity1.genes[i]
        entity1.genes[i] = entity2.genes[i]
        entity2.genes[i] = x
    end
end

function mutation!(entity, mutationPercentage)
    if (rand(Float64) < mutationPercentage)
        mutationPoint = rand(1:length(entity.genes))

        if entity.genes[mutationPoint] > 0
            entity.genes[mutationPoint] -= 0.1
        else
            entity.genes[mutationPoint] += 0.1
        end
    end
end

function printEntity(entity)
    for i in 1:length(entity.genes)
        print("$(round.(entity.genes[i]; digits = 3)) ")		# zaokruživanje na 3 decimale (iza tačke)
    end
    println("$(entity.fitness)")
end

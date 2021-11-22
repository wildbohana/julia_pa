# zadatak 1

mutable struct Entity
    genes::Array{Float64, 1}
    fitness::Float64
end

function generateEntity(genesLength)
    return Entity(rand(-1.0:0.0001:1, genesLength), 0)
end

function printEntity(entity)
    for i in 1:length(entity.genes)
        print("$(round.(entity.genes[i]; digits = 3)) ")
    end
    println("$(entity.fitness)")
end

function calculateFitness!(entity)
    x = entity.genes[1]
    y = entity.genes[2]
    z = entity.genes[3]
    w = entity.genes[4]
    u = entity.genes[5]
    v = entity.genes[6]

    entity.fitness = abs(4*x^2 - 6*x - 3*y^3 + 0.5*y + 3*z + 8*w - 6.1*u + 2*v - 10)
end

function crossover!(entity1, entity2, crossoverPoint)
    for i in 1:crossoverPoint
        x = entity1.genes[i]
        entity1.genes[i] = entity2.genes[i]
        entity2.genes[i] = x
    end
end

function mutate!(entity, mutationPercentage)
    if rand(Float64) < mutationPercentage
        mutationPoint = rand(1:length(entity.genes))
        
        if entity.genes[mutationPoint] > 0
            entity.genes[mutationPoint] -= 0.1 
        else
            entity.genes[mutationPoint] += 0.1 
        end
    end
end

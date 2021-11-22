# zadatak 1

include("ant.jl")

using StatsBase

function AntColonyOptimization!(graphNodes, maxIterations, antsNumber, pheromoneDepositFactor, evaporationRate, pheromoneExponent, desirabilityExponent, graph)
    bestFitness = Inf
    bestPath = []

    for i in 1:maxIterations
        ants = generateAntPopulation(antsNumber, 1)

        for j in 1:antsNumber
            currentAnt = ants[j]
            antMadeTour = false
            antStartNode = currentAnt.currentNodeIndex
            while !antMadeTour 
                possiblePaths = findPossiblePaths(currentAnt, graph)
                probabilities = calculateProbabilities(currentAnt, possiblePaths, graph, pheromoneExponent, desirabilityExponent)
                chosenNode = sample(possiblePaths, Weights(probabilities))
                
                push!(currentAnt.route, currentAnt.currentNodeIndex)
                currentAnt.currentNodeIndex = chosenNode
                if chosenNode == antStartNode
                    antMadeTour = true
                    push!(currentAnt.route, currentAnt.currentNodeIndex)
                end
            end
            fitness = calculateFitness(ants[j], graph)
            ants[j].fitness = fitness

            if fitness < bestFitness
                bestFitness = fitness
                bestPath = deepcopy(ants[j].route)
            end
        end
        updatePheromones!(ants, graph, pheromoneDepositFactor, evaporationRate)
    end
    return bestPath, bestFitness, graph
end

function updatePheromones!(ants, graph, pheromoneDepositFactor, evaporationRate)
    pheromoneDepositMatrix = zeros(Float64, graph.nodesCount, graph.nodesCount)

    # PRORACUN NIVOA FEROMONA SVAKE JEDINKE MRAVA PONAOSOB I CUVANJE U MATRICU FEROMONA
    for currentAnt in ants
        route = currentAnt.route

        for j in 1:length(currentAnt.route) - 1
            pheromoneDepositMatrix[route[j], route[j + 1]] += pheromoneDepositFactor / currentAnt.fitness
        end
    end

    for i in 1:graph.nodesCount 
        for j in (i+1):graph.nodesCount
            pheromone = graph.pheromoneMatrix[i, j]
            graph.pheromoneMatrix[i, j] = (1 - evaporationRate) * pheromone +  pheromoneDepositMatrix[i, j]
            graph.pheromoneMatrix[j, i] =  graph.pheromoneMatrix[i, j]
        end
    end
end

function calculateProbabilities(ant::Ant, possiblePaths::Array{Int, 1}, graph::Graph, pheromoneExponent, desirabilityExponent)
    pathsSum = 0
    # Racunanje komulativne sume feromona i duzine uticaja za sve moguce putanje od trenutnog cvora gde se mrav nalazi
    for possibleNode in possiblePaths
            pathsSum += ( ( (graph.pheromoneMatrix[ant.currentNodeIndex, possibleNode]) ^ pheromoneExponent ) * 
	                (1 / graph.adjMatrix[ant.currentNodeIndex, possibleNode]) ^ desirabilityExponent )
    end

    probabilities = Float64[] 

    for possibleNode in possiblePaths
        push!(probabilities, ( ( (graph.pheromoneMatrix[ant.currentNodeIndex, possibleNode]) ^ pheromoneExponent ) * 
	      (1 / graph.adjMatrix[ant.currentNodeIndex, possibleNode]) ^ desirabilityExponent ) / pathsSum)
    end

    return probabilities
end

function findPossiblePaths(ant::Ant, graph::Graph)
    possiblePaths = findall(graph.adjMatrix[ant.currentNodeIndex, :] .!= -1)
    
    if !isempty(ant.route)
        for city in ant.route
            # UKLONI GRAD KOJI JE VEC POSECEN
            if city in possiblePaths
                filter!(x -> x != city, possiblePaths)
            end
        end
    end

    # AKO SU SVI GRADOVI OBIDJENI, VRATI SE U POCETNI GRAD TJ CVOR
    if isempty(possiblePaths)
        push!(possiblePaths, ant.route[1])
    end
    return possiblePaths
end

function calculateFitness(ant::Ant, graph::Graph)
    pathLength = 0
    for i in 1:(length(ant.route) - 1)
        pathLength += graph.adjMatrix[ ant.route[i], ant.route[i + 1]]        
    end
    return pathLength
end

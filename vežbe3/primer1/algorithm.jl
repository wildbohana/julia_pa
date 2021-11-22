include("swarm.jl")

function calculateGlobalBestParticle(swarm, targetValue, globalBestParticle)
    for i in 1:length(swarm)
        if abs(swarm[i].currentValue - targetValue) < abs(globalBestParticle.currentValue - targetValue)
            globalBestParticle = deepcopy(swarm[i])
        end
    end
    return globalBestParticle
end

function PsoAlgorithm!(swarm, targetValue, maxIteration, maxVelocity)
    globalBestParticle = swarm[1]
    globalBestParticle = calculateGlobalBestParticle(swarm, targetValue, globalBestParticle)

    for i in 1:maxIteration
        if globalBestParticle == targetValue
	    # kad nađe traženu vrednost, odštampa je i odmah izlazi iz cele funkcije
            printSwarm(swarm)
            println("-- RESENJE --")
            printParticle(globalBestParticle)
            println("RESENJE PRONADJENO POSLE $i ITERACIJA.")
            return
        end	
	# ako u ovoj iteraciji nije našao traženo rešenje, onda računamo novo globalno najbolje
        updateSwarmVelocity!(swarm, globalBestParticle, maxVelocity)
        updateSwarmPosition!(swarm, targetValue)    
        globalBestParticle = calculateGlobalBestParticle(swarm, targetValue, globalBestParticle)
    end
    # ako ni jedna iteracija nije pronašla traženo rešenje, onda štampaj globalno najbolje
    printSwarm(swarm)
    println("\nGLOBALNO RESENJE")
    printParticle(globalBestParticle)
end

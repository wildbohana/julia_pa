# zadatak 1

include("particle.jl")

function generateSwarm(numberOfParticles, numberOfOperands, minRang, maxRang)
    swarm = []
    for i in 1:numberOfParticles
        particle = generateParticle(numberOfOperands, minRang, maxRang)
        push!(swarm, particle)
    end
    return swarm
end

function printSwarm(swarm)
    for i in 1:length(swarm)
        printParticle(swarm[i])
    end
end

function updateSwarmVelocity!(swarm, globalBestParticle, maxVelocity)
    for i in 1:length(swarm)
        updateVelocity!(swarm[i], globalBestParticle, maxVelocity)
    end
end

function updateSwarmPosition!(swarm, targetValue)
    for i in 1:length(swarm)
        updatePosition!(swarm[i], targetValue)
    end
end

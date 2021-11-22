# zadatak 1

mutable struct Particle
    values::Array{Float64, 1}
    currentValue::Float64
    velocity::Array{Float64, 1}
    bestValues::Array{Float64, 1}
    bestValue::Float64
end

function updateValue!(particle)
    x = particle.values[1]
    y = particle.values[2]
    z = particle.values[3]
    w = particle.values[4]
    u = particle.values[5]
    v = particle.values[6]
    particle.currentValue = 4*x^2 - 6*x - 3*y^3 + 0.5*y + 3*z + 8*w - 6.1*u +2*v - 10
end

function generateParticle(numberOfOperands, minRang, maxRang)
    particle = Particle(rand(minRang:0.1:maxRang, numberOfOperands), 0, fill(0.0, numberOfOperands), fill(0, numberOfOperands), 0)
    updateValue!(particle)
    particle.bestValues = copy(particle.values)
    particle.bestValue = particle.currentValue

    return particle
end

function printParticle(particle)
    x = particle.values[1]
    y = particle.values[2]
    z = particle.values[3]
    w = particle.values[4]
    u = particle.values[5]
    v = particle.values[6]
    println("4*$x^2 - 6*$x - 3*$y^3 + 0.5*$y + 3*$z + 8*$w - 6.1*$u +2*$v - 10 = $(particle.currentValue)")
end

# Vi = Cv*Vi + Cp*Rp*(Pi-Xi) + Cg*Rg*(g-Xi)
# Xi - trenutna vrednost
# Pi - lokalno najbolja
# g  - globalno najbolja
# Cv = 1 Cp = 2 Cg = 2
function updateVelocity!(particle, globalBestParticle, maxVelocity)
    rp = rand(Float64)
    rg = rand(Float64)

    for i in 1:length(particle.velocity)
        particle.velocity[i] = 1.0 * particle.velocity[i]  +  2.0 * rp * (particle.bestValues[i] - particle.values[i])  +  2.0 * rg * (globalBestParticle.values[i] - particle.values[i])
		if particle.velocity[i] > maxVelocity
            particle.velocity[i] = maxVelocity
        elseif particle.velocity[i] < -maxVelocity
            particle.velocity[i] = -maxVelocity				# maxVelocity = 0.2 (svaka iteracija maksimalno može za 0.2 da poveća vrednost operanada)
        end
    end
end

function updatePosition!(particle, targetValue)
    for i in 1:length(particle.values)
        particle.values[i] += particle.velocity[i]

        if particle.values[i] > 1
            particle.values[i] = 1.0					# vrednost pozicije mora biti između 1.0 (maxRang)
        elseif particle.values[i] < -1
            particle.values[i] = -1.0					# i -1.0 (minRang)
        end
    end
    updateValue!(particle)
    if abs(particle.currentValue - targetValue) < abs(particle.bestValue - targetValue)
        particle.bestValues = copy(particle.values)
        particle.bestValue  = particle.currentValue
    end
end

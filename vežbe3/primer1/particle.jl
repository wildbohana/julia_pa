# primer 1

mutable struct Particle
    values::Array{Int64, 1}					# pozicije do sad
    currentValue::Int64						# trenutna pozicija (zbir dosadašnjih pozicija)
    velocity::Array{Float64, 1}					# brzina
    bestValues::Array{Float64, 1}				# najbolje pozicije čitavog rešenja
    bestValue::Int64						# njena najbolja pozicija
end

function updateValue!(particle)
    particle.currentValue = sum(particle.values)
end

function generateParticle(numberOfOperands, minRang, maxRang)
    particle = Particle(rand(minRang:maxRang, numberOfOperands), 0, fill(0.0, numberOfOperands), fill(0, numberOfOperands), 0)
    updateValue!(particle)
    particle.bestValues = copy(particle.values)
    particle.bestValue = particle.currentValue

    return particle
end

function printParticle(particle)
    for i in 1:length(particle.values)
        if i < length(particle.values)
            print(particle.values[i], " + ")			# plus između sabiraka
        else
            print(particle.values[i], " = ")			# jednako pre rešenja
        end
    end
    println(particle.currentValue)				# rešenje (tj zbir)
end

# Vi = Cv*Vi + Cp*Rp*(Pi-Xi) + Cg*Rg*(g-Xi)
# Xi - trenutna vrednost
# Pi - lokalno najbolja
# g - globalno najbolja
# Cv = 1 Cp = 2 Cg = 2
function updateVelocity!(particle, globalBestParticle, maxVelocity)
    rp = rand(Float64)
    rg = rand(Float64)
    for i in 1:length(particle.velocity)
        particle.velocity[i] = 1.0 * particle.velocity[i]  +  2.0 * rp * (particle.bestValues[i] - particle.values[i])  +  2.0 * rg * (globalBestParticle.values[i] - particle.values[i])

        if particle.velocity[i] > maxVelocity			# ako je veća od najveće dozvoljene brzine, smanji na tu najveću dozvoljenu
            particle.velocity[i] = maxVelocity
        elseif particle.velocity[i] < -maxVelocity		# ako je manja od najmanje dozvoljene brzine, povećaj na tu najmanju dozvoljenu
            particle.velocity[i] = -maxVelocity
        end
    end
end

function updatePosition!(particle, targetValue)
    for i in 1:length(particle.values)
        particle.values[i] += trunc(Int64, particle.velocity[i])
    end
    updateValue!(particle)

    # ako je razlika između trenutne vrednosti i ciljne vrednosti manja od razlike najbolje vrednosti i ciljne vrednosti, sačuvaj trenutnu vrednost kao najbolju vrednost do sad
    if abs(particle.currentValue - targetValue) < abs(particle.bestValue - targetValue)
        particle.bestValues = copy(particle.values)
        particle.bestValue = particle.currentValue
    end
end

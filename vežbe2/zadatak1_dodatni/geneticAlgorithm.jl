# zadatak 1

include("population.jl")
function converge(bestFits)
    len = length(bestFits)					# bestFits je niz sa najboljim fitnessom za svaku generaciju
    if bestFits[len] < 0.01					# da li je najnoviji fitness (poslednji dodat u niz) dovoljno mali da bi ispunio uslov konvergencije
        return true
    elseif len < 3						# ovo kao mora da se prođe kroz bar 3 generacije? tj populacije da bi uopšte pronašli rešenje??
        return false
    elseif (bestFits[len - 2] - bestFits[len]) < 0.001		# da li je razlika malo daljih komšija dovoljno mala da bi se smatrala konvergencijom
        return true	
    else
        return false
    end
end

function geneticAlgorithm!(data, elitePercentage, crossoverPoint, mutationPercentage)
    calculatePopulationFitness!(data)
    populationSize = length(data)
    eliteSize = Int(trunc(elitePercentage * populationSize))

    # Ako je velicina elite neparan broj dodaj 1
    eliteSize = eliteSize + (populationSize - eliteSize) % 2
    bestFits = data[1].fitness					# jedinka sa najboljim fitnessom (index 1) u data populaciji (generaciji)

    while !converge(bestFits)
        elite = deepcopy(selectPopulation(data, eliteSize))
        data = selectPopulation(data, populationSize - eliteSize)
        data = crossoverPopulation!(data, crossoverPoint)
        mutatePopulation!(data, mutationPercentage)
        data = [data; elite]
        calculatePopulationFitness!(data)
        bestFits = [bestFits; data[1].fitness]			# stari bestFits, novi bestFit
    end
    return length(bestFits), data				# ovo ti manje više govori koliko puta se izvršila while petlja (tj koliko generacija je prošlo) i vraća zadnju generaciju
end

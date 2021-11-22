# zadatak 2

include("geneticAlgorithm.jl")

numberOfRocks = 20
values = rand(1:100, numberOfRocks)								# niz sa vrednostima
weights = rand(1:10, numberOfRocks)								# niz sa težinama
maxCapacity = 30
populationSize = 50
crossoverPoint1 = 7
crossoverPoint2 = 14
mutationPercentage = 0.1
elitePercentage = 0.1

population = generatePopulation(populationSize, numberOfRocks)
popGen, population = geneticAlgorithm!(population, elitePercentage, crossoverPoint1, crossoverPoint2, mutationPercentage, values, weights, maxCapacity)

printPopulation(population)
println("Ukupan broj kamenja je $numberOfRocks")
println("Tezine kamenja su $weights")
println("Vrednosti kamenja su $values")
println("Maksimalna tezina kamenja je $maxCapacity")
println("Rezultati: ")
sumWeights = sum(weights[population[1].genes .== 1])

if sumWeights > maxCapacity
    println("Nije pronajdeno resenje")
else
    println("Tezina izabranog kamenja je: $sumWeights")
    value = sum(values[population[1].genes .== 1])
    println("Vrednost izabranog kamenja je: $value")
    println("Ukupan broj generacija je $popGen")
    println("Idealna jedinka $(population[1])")
    println("Izabrana su kamenja sa rednim brojevima:")

    for i in 1:numberOfRocks
        if population[1].genes[i] == 1
            print("$i ")
        end
    end
end

include("analyse.jl")

genesLength = 6
populationSize = 50
crossoverPoint = 3
crossoverRange = collect(2:5)
mutationPercentage = 0.1
mutationRange = collect(0:0.01:0.3)
elitePercentage = 0.1
eliteRange = collect(0:0.01:0.3)
numOfIterations = 200

population = generatePopulation(populationSize, genesLength)

minIndex, optimalElite, resultsFit, resultsGen = findBestElitePercentage(population, eliteRange, crossoverPoint, mutationPercentage, numOfIterations)
println("Detekcija optimalnih vrednosti za procenat elite u populaciji")
println("Vrednost procenta elite za detekciju: $eliteRange")
println("Najbolji prosecan fitness : $optimalElite")
println("Redni broj optimalnog procenta elite u nizu: $minIndex")
println("Najbolji procenat elite: $(eliteRange[minIndex])")
println("Prosecna vrednost fitnesa: $(round.(resultsFit, digits = 4))")
println("Prosecan broj generacija: $resultsGen")

minCrossIndex, minMutIndex, optimalValue, resultsFit, resultsGen = findBestCrossoverAndMutation(population, elitePercentage, crossoverRange, mutationRange, numOfIterations)
println()
println("Detekcija optimalnih vrednosti za tacku ukrstanja i procenat mutacije u populaciji")
println("Vrednost tacke ukrstanja za detekciju: $crossoverRange")
println("Vrednost procenta mutacije za detekciju: $mutationRange")
println("Najbolji prosecan fitness : $optimalValue")
println("Najbolja tacka ukrstanja: $(crossoverRange[minCrossIndex])")
println("Najbolji procenat mutacije: $(mutationRange[minMutIndex])")
println("Prosecne vrednosti fitnesa:")
display(transpose(round.(resultsFit, digits = 4)))
println("Prosecan broj generacija:")
display(transpose(resultsGen))

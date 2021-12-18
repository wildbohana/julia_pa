using StatsModels
using GLM
using DataFrames
using CSV
using Lathe.preprocess: TrainTestSplit
using Plots
using Statistics
using StatsBase
using MLBase
using ROC

data = DataFrame(CSV.File("pacijenti1000a.jl"))

dataTrain, dataTest = TrainTestSplit(data, .80)

fm = @formula(bolest ~ visina + tezina + sbp + dbp)
logReg = glm(fm, dataTrain, Binomial(), LogitLink())

dataPredictedTest = predict(logReg, dataTest)

dataPredictedTestClass = repeat(0.0, length(dataPredictedTest))
for i in 1:length(dataPredictedTest)
	if dataPredictedTest > 0.5
		dataPredictedTestClass[i] = 1
	else
		dataPredictedTestClass[i] = 0
	end
end

brojObolelihPredict = sum(dataPredictedTestClass)
brojZdravihPredict = length(dataPredictedTestClass) - brojObolelihPredict

brojObolelih = sum(dataTest.bolest)
brojZdravih = length(dataTest.bolest) - brojObolelih

println("Predviđen broj obolelih je: $brojObolelihPredict")
println("Broj obolelih osoba je: $brojObolelih")

println("Predviđen broj zdravih je: $brojZdravihPredict")
println("Broj zdravih osoba je: $brojZdravih")

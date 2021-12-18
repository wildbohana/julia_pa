using Statistics
using StatsModels
using StatsBase
using GLM
using DataFrames
using CSV
using Lathe
using Plots
using StatsPlots

data = DataFrame(CSV.File("motor_cena.csv"))

display(describe(data))
display(countmap(data[!, :Boja]))
display(countmap(data[!, :Tip]))
display(countmap(data[!, :Ostecenje]))
display(countmap(data[!, :Stanje]))

dropmissing!(data, [:Cena])					# izbaci one bez cene
filter!(row -> row.Cena != 0, data)			# izbaci one kojima je cena 0

select!(data, Not(:Boja))					# izbaci celu kolonu Boja

data[ismissing.(data[!, :Stanje]), :Stanje] .= mode(skipmissing(data[!, :Stanje]))
data[ismissing.(data[!, :Ostecenje]), :Ostecenje] .= mode(skipmissing(data[!, :Ostecenje]))
data[ismissing.(data[!, :Kilometraza]), :Kilometraza] .= trunc(Int64, mean(skipmissing(data[!, :Kilometraza])))

display(describe(data))

plotgod = scatter(data.Godiste, data.Cena, title = "Scatter Godište - Cena", ylabel = "Cena", xlabel = "Godište", legend = true)
savefig(plotgod, "godistescatter.html")

plotkm = scatter(data.Kilometraza, data.Cena, title = "Scatter Kilometraža - Cena", ylabel = "Cena", xlabel = "Kilometraza", legend = true)
savefig(plotkm, "kilometrazascatter.html")

plotkw = scatter(data.kW, data.Cena, title = "Scatter kW - Cena", ylabel = "Cena", xlabel = "kW", legend = true)
savefig(plotkm, "kwscatter.html")

plotks = scatter(data.KS, data.Cena, title = "Scatter KS - Cena", ylabel = "Cena", xlabel = "KS", legend = true)
savefig(plotks, "ksscatter.html")

plotcil = scatter(data.BrojCilindara, data.Cena, title = "Scatter Br.Cil. - Cena", ylabel = "Cena", xlabel = "Br. Cilindara", legend = true)
savefig(plotcil, "brojCilindarascatter.html")

filter!(row -> row.Godiste <= 2021 && row.Godiste > 1900, data)
filter!(row -> row.Kilometraza <= 500000, data)
filter!(row -> row.BrojCilindara > 0 && row.BrojCilindara < 300, data)

covKwKS = cov(data.kW, data.KS)

if covKwKS > 0.6
	select!(data, Not(:kW))
end

fm = @formula(Cena ~ Stanje + Tip + Godiste + Kilometraza + Kubikaza + KS + BrojCilindara + Ostecenje)
dataTrain, dataTest = Lathe.preprocess.TrainTestSplit(data, .75)
linReg = lm(fm, dataTrain)

predictTest = predict(linReg, dataTest)
predictTrain = predict(linRg, dataTrain)

errorsTest = dataTest.cena - predictTest
errorsTrain = dataTrain.cena - predictTrain

rmseTest = sqrt(mean(errorsTest .* errorsTest))
rmseTrain = sqrt(mean(errorsTrain .* errorsTrain))

println()
println("RMSE trening skupa je $rmseTrain, a test skupa je $rmseTest")

rSquared = r2(logReg)
println(rSquared)
if rSquared > 0.5
	println("Imamo dovoljno dobar model za predviđanje.")
end

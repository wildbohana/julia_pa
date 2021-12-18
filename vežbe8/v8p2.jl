using DataFrames
using CSV
using StatsBase
using StatsModels
using Statistics
using Plots, StatsPlots
using ROC
using GLM
using Lathe

data = DataFrame(CSV.File("riba.csv"))
display(describe(data))

display(countmap(data[!, :Cena]))
select!(data, Not(:Cena))				# izbacimo cenu jer cenu tražimo, duuh

display(countmap(data[!, :Vrsta]))
data[ismissing.(data[!, :Vrsta]), :Vrsta] .= mode(skipmissing(data[!, :Vrsta]))

data[ismissing.(data[!, :Duzina]), :Duzina] .= mean(skipmissing(data[!, :Duzina]))

display(describe(data))

plot = scatter(data.Vrsta, data.Tezina, title = "Tezina - Vrsta", xlabel = "Vrsta", ylabel = "Tezina", legend = true)
savefig(plot, "vrstaTezina.html")

plot = scatter(data.DuzinaVertikalna, data.Tezina, title = "Tezina - DuzinaVertikalna", xlabel = "DuzinaVertikalna", ylabel = "Tezina", legend = true)
savefig(plot, "duzinaVertikalnaTezina.html")

plot = scatter(data.DuzinaDijagonalna, data.Tezina, title = "Tezina - DuzinaDijagonalna", xlabel = "DuzinaDijagonalna", ylabel = "Tezina", legend = true)
savefig(plot, "duzinaDijagonalnaTezina.html")

plot = scatter(data.Duzina, data.Tezina, title = "Tezina - Duzina", xlabel = "Duzina", ylabel = "Tezina", legend = true)
savefig(plot, "duzinaTezina.html")

plot = scatter(data.Visina, data.Tezina, title = "Tezina - Visina", xlabel = "Visina", ylabel = "Tezina", legend = true)
savefig(plot, "visinaTezina.html")

plot = scatter(data.Sirina, data.Tezina, title = "Tezina - Sirina", xlabel = "Sirina", ylabel = "Tezina", legend = true)
savefig(plot, "sirinaTezina.html")

covDuzDijagVert = cov(data.DuzinaDijagonalna, data.DuzinaVertikalna)
if covDuzDijagVert > 0.6
	select!(data, Not(:DuzinaVertikalna))
end

covDuzDijag = cov(data.DuzinaDijagonalna, data.Duzina)
if covDuzDijag > 0.6
	select!(data, Not(:Duzina))
end

filter!(row -> row.Tezina <= 1500, data)

fm = @formula(Tezina ~ Vrsta + DuzinaDijagonalna + Visina + Sirina)
dataTrain, dataTest = Lathe.preprocess.TrainTestSplit(data, .75)
logReg = lm(fm, dataTrain)

predictTest = predict(logReg, dataTest)
predictTrain = predict(logTef, dataTrain)

errorTest = dataTest.Tezina - predictTest
errorTrain = dataTrain.Tezina - predictTrain

rmseTest = sqrt(mean(errorTest .* errorTest))
rmseTrain = sqrt(mean(errorTrain .* errorTrain))

println("RMSE test $rmseTest, RMSE train $rmseTrain")

println(r2(logReg))

if r2(logReg) > 0.5
	println("Imamo dovoljno dobar model za predviđanje.")
end

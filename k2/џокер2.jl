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

select!(data, Not(:Cena))
filter!(row -> row.Tezina != 0, data)

dropmissing!(data, [:Duzina])

display(describe(data))

plot = scatter(data.Vrsta, data.Tezina, title = "Tezina - Vrsta", ylabel = "Tezina", xlabel = "Vrsta", legend = true)
savefig(plot, "VrstaTezina.html")

covDuzDijag = cov(data.DuzinaDijagonalna, data.Duzina)
if covDuzDijag > 0.6
	select!(data, Not(:Duzina))
end

fm = @formula(Tezina ~ Vrsta + DuzinaDijagonalna + Visina + Sirina)
dataTrain, dataTest = Lathe.preprocess.TrainTestSplit(data, .75)
linReg = lm(fm, dataTrain)

dataPredictTest = predict(linReg, dataTest)

errorsTest = dataTest.Tezina - dataPredictTest

# mapeTrain = mean(abs.(errorsTrain ./ dataTrain.y))
# absMeanErrorTrain = mean(abs.(errorsTrain))
rmseTest = sqrt(mean(errorsTest .* errorsTest))

println("RMSE testa iznosi: $rmseTest")
#=
if (rmseTrain < rmseTest)
	println("Sistem je dobro istreniran")
 else
	println("Sistem nije dobro istreniran")
 end
 =#

println(r2(linReg))

if r2(linReg) > 0.5
	println("Imamo dovoljno dobar model za predviđanje.")
end

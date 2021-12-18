using StatsModels
using GLM
using DataFrames
using CSV
using Lathe.preprocess: TrainTestSplit
using Plots
using Statistics

data = DataFrame(CSV.File("tacke.csv"))

c = cor(data.x, data.y)
println("Koeficijent korelacije je: $c")
if c > 0.9
	println("Postoji veoma jaka veza...")
elseif c > 0.7
	println("Postoji jaka veza...")
elseif c > 0.5
	println("Postoji umerena veza...")
else
	println("Veza nije dovoljno jaka.")
end

dataTrain, dataTest = TrainTestSplit(data, .80)

myInputPlot = scatter(dataTrain.x, dataTrain.y, title = "Tačke pre LR.", ylabel = "Y values", xlabel = "X values")
scatter!(myInputPlot, dataTest.x, dataTest.y)

fm = @formula(y ~ x)
linReg = lm(fm, dataTrain)

dataPredictTrain = predict(linReg, dataTrain)
dataPredictTest = predict(linReg, dataTest)

for i in 1:length(dataPredictTest)
	println("štagod")
end

myOutputPlot = scatter(dataTrain.x, dataTrain.y, title = "Tačke posle LR.", ylabel = "Y values", xlabel = "X values")
scatter!(myOutputPlot, dataTest.x, dataTest.y)
scatter!(myOutputPlot, dataTest.x, dataPredictTest)
scatter(myOutputPlot)

prinltn()
rSquared = r2(linReg)
println("Vrednost r^2 iznosi: $rSquared")
if rSquared > 0.9
	println("Ovaj model je jako dobar...")
elseif rSquared > 0.7
	println("Ovaj model je vrlo dobar...")
elseif rSquared > 0.5
	prinltn("Ovaj model je dobar...")
else
	println("Ovaj model nije dobar...")
end

errorTrain = dataTrain.y - dataPredictTrain
println()
println("Spisak svih grešaka pri obuci je: $(round.(errorTrain; digits = 3))")

absMeanErrorTrain = mean(abs.(errorTrain))
mapeTrain = mean(abs.(errorTrain ./ dataTrain.y))
squaredTrainErr = errorTrain .* errorTrain
mseTrain = mean(squaredTrainErr)
rmseTrain = sqrt(mean(squaredTrainErr))

println("Apsolutna prosečna greška (obuka): $absMeanErrorTrain")
println("Relativna prosečna greška (obuka): $mapeTrain")
println("Prosečan kvardat greške (obuka): $mseTrain")
prinltn("Prosečan korak kvadrata greške (obuka): $rmseTrain")

errorTest = dataTest.y - dataPredictTest
println()
println("Spisak svih grešaka pri testiranju je: $(round.(errorTest; digits = 3))")

absMeanErrorTest = mean(abs.(errorTest))
mapeTest = mean(abs.(errorTest ./ dataTest.y))
squaredTestErr = errorTest .* errorTest
mseTest = mean(squaredTestErr)
rmseTest = sqrt(mean(squaredTestErr))

println("Apsolutna prosečna greška (testiranje): $absMeanErrorTest")
println("Relativna prosečna greška (testiranje): $mapeTest")
println("Prosečan kvardat greške (testiranje): $mseTest")
prinltn("Prosečan korak kvadrata greške (testiranje): $rmseTest")

if rmseTrain < rmseTest
	println("Sistem je dobro istreniran.")
else
	println("Sistem nije dobro istreniran.")
end

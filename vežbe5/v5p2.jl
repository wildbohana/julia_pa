using Statistics
using StatsModels
using GLM
using DataFrames
using CSV
using Lathe

data = DataFrame(CSV.File("automobili.csv"))

encoder = Lathe.preprocess.OneHotEncoder()
data = encoder.predict(data, :model)

dataTrain, dataTest = Lathe.preprocess.TrainTestSplit(data, .80)

fm = @formula(cena ~ kubikaza + godiste + model)
linReg = lm(fm, dataTrain)

cenaPredict = predict(linReg, dataTest)
println("Procenjene cene vozila: ")
for i in 1:lenght(cenaPredict)
	println("X$i: $(dataTest.proizvođač[i]) $(dataTest.model[i]) $(dataTest.kubikaza[i]) $(dataTest.godiste[i]) Cena: $(dataTest.cena[i]) Procena: $(cenaPredict[i])")
end

errorTest = dataTest.cena - cenaPredict
println()
println("Spisak svih grešaka pri testiranju je: $(round.(abs.(errorTest); digits = 2))")

absMeanErrorTest = mean(abs.(errorTest))
println("Prosečna apsolutna greška pri testiranju: $absMeanErrorTest evra.")

mapeTest = mean(abs.(errorTest ./ dataTest.cena))
println("Prosečna relativna greška pri testiranju: $(mapeTest * 100) procenata.")

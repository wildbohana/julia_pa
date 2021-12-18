using StatsModels
using GLM
using DataFrames
using CSV
using Statistics
using MLBase

data = DataFrame(CSV.File("tacke40c.jl"))
fm = @formula(y ~ x)

k = 5
a = collect(Kfold(length(data.x), k))

averageAbsMeanErrorTest = 0.0
for i in 1:k
	dataTrain = data[a[i], :]
	dataTest = data[setdiff(1:end, a[i]), :]
	linReg = lm(fm, dataTrain)
	dataPredictTest = predict(linReg, dataTest)

	errorsTest = dataTest.y - dataPredictTest
	absMeanErrorTest = mean(abs.(errorsTest))

	println("Prosečna apsolutna greška za test $i je: $absMeanErrorTest")
	global averageAbsMeanErrorTest += absMeanErrorTest
end

averageAbsMeanErrorTest /= k
println("Prosečna apsolutna greška za $k testiranja je: $averageAbsMeanErrorTest")


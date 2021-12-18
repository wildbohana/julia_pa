using StatsModels
using Statistics
using GLM
using CSV
using DataFrames
using Lathe.preprocess: TrainTestSplit
using Plots
using StatsBase
using MLBase
using ROC

data = DataFrame(CSV.File("tacke1000a.csv"))

dataTrain, dataTest = TrainTestSplit(data, .80)

myInputPlot = scatter(dataTrain.x, dataTrain.y, title = "Tačke pre LR:", ylabel = "Y values", xlabel = "X values")
scatter!(myInputPlot, dataTest.x, dataTest.y)

fm = @formula(boja ~ x + y)
logReg = glm(fm, dataTrain, Binomial(), LogitLink())

dataPredictTest = predict(logReg, dataTest)
println("Predviđeni podaci: $(round.(dataPredictTest; digits = 2))")

dataPredictTestClass = repeat(0:0, length(dataPredictTest))
for i in 1:length(dataPredictTest)
	if dataPredictTest > 0.5
		dataPredictTestClass[i] = 1
	else
		dataPredictTestClass[i] = 0
	end
end

println("Predviđena boja: $dataPredictedTestClass")
println("Boja: $(dataTest.boja)")

FPTest = 0
FNTest = 0
TPTest = 0
TNTest = 0

for i in 1:length(dataPredictTestClass)
	if dataTest.boja[i] == 0 && dataPredictTestClass[i] == 0
		TNTest += 1
	elseif dataTest.boja[i] == 0 && dataPredictTestClass[i] == 1
		FPTest += 1
	elseif dataTest.boja[i] == 1 && dataPredictTestClass[i] == 1
		TPTest += 1
	elseif dataTest.boja[i] == 1 && dataPredictTestClass[i] == 0
		FNTest += 1
	end
end

accuracyTest = (TPTest + TNTest) / (TPTest + TNTest + FPTest + FNTest)
sensitivityTest = TPTest / (TPTest + FNTest)
specificityTest = TNTest / (TNTest + FPTest)

println("TP = $TPTest, FP = $FPTest, TN = $TNTest, FN = $FNTest")
println("Preciznost za test skup: $accuracyTest")
println("Osetljivost za test skup: $sensitivityTest")
println("Specifičnost za test skup: $specificityTest")

rocTest = ROC.roc(dataPredictTestClass, dataTest.boj, true)
aucTest = AUS(rocTest)
println("Površina ispod krive u procentima je: $aucTest")

if auc > 0.9
	println("Kasifikator je odličan.")
elseif auc > 0.5
	println("Klasifikator radi posao.")
else
	println("neradi.")
end

plot(rocTest, label = "ROC curve")

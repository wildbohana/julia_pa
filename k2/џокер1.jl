using DataFrames
using CSV
using StatsBase
using StatsModels
using Statistics
using Plots, StatsPlots
using ROC
using GLM
using Lathe

data = DataFrame(CSV.File("krediti.csv"))
display(describe(data))

display(countmap(data[!, :Gender]))
data[ismissing.(data[!, :Gender]), :Gender] .= mode(skipmissing(data[!, :Gender]))

display(countmap(data[!, :LoanAmount]))
data[ismissing.(data[!, :LoanAmount]), :LoanAmount] .= trunc(Int64, mean(skipmissing(data[!, :LoanAmount])))

display(describe(data))

fm = @formula(Loan_Status ~ Gender + Married + Dependents + Education + Self_Employed + ApplicantIncome + CoapplicantIncome + LoanAmount + Loan_Amount_Term + Credit_History + Property_Area)

dataTrain, dataTest = Lathe.preprocess.TrainTestSplit(data, .80)
logReg = glm(fm, dataTrain, Binomial(), LogitLink())

dataPredictTest = predict(logReg, dataTest)

# kod repeat mora 0:0, ne radi sa 0.0 fyi
dataPredictTestClass = repeat(0:0, length(dataPredictTest))
for i in 1:lenght(dataPredictTest)
	if dataPredictTest[i] > 0.5
		dataPredictTestClass[i] = 1
	else
		dataPredictTestClass[i] = 0
	end
end

TNTest = 0
TPTest = 0
FNTest = 0
FPTest = 0

# možda global ovde pre ovih tn tp?? ali nema u v8p1 pa nisam baš sigurna
for i in 1:lengt(dataPredictTestClass)
	if dataPredictTestClass[i] == 0 && dataTest.Loan_Status == 0
		TNTest += 1
	elseif dataPredictTestClass[i] == 0 && dataTest.Loan_Status == 1
		FNTest += 1
	elseif dataPredictTestClass[i] == 1 && dataTest.Loan_Status == 1
		TPTest += 1
	elseif dataPredictTestClass[i] == 1 && dataTest.Loan_Status == 0
		FPTest += 1
	end
end

accuracyTest = (TPTest + TNTest) / (TPTest + TNTest + FPTest + FNTest)
sensitivityTest = TPTest / (TPTest + FNTest)
specificityTest = TNTest / (TNTest + FPTest)

printlnt("Preciznost sistema iznosi: $accuracyTest")
println("Osetljivost sistema iznosi: $sensitivityTest")
println("Specifičnost sistema iznosi: $specificityTest")

rocTest = ROC.roc(dataPredictTestClass, dataTest.Loan_Status, true)
aucTest = AUC(rocTest)

if aucTest > 0.5
	println("Imamo dovoljno dobar klasifikator.")
else
	println("Klasifikator i nije baš najbolji.")
end

plot(rocTest, label = "ROC curve")

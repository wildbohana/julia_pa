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

display(countmap(data[!, :Married]))
data[ismissing.(data[!, :Married]), :Married] .= mode(skipmissing(data[!, :Married]))

display(countmapt(data[!, :Dependents]))
data[ismissing.(data[!, :Dependents]), :Dependents] .= mode(skipmissing(data[!, :Dependents]))

display(countmap(data[!, :Self_Employed]))
data[ismissing.(data[!, :Self_Employed]), :Self_Employed] .= mode(skipmissing(data[!, :Self_Employed]))

data[ismissing.(data[!, :LoanAmount]), :LoanAmount] .= trunc(Int64, mean(skipmissing(data[!, :LoanAmount])))

data[ismissing.(data[!, :Loan_Amount_Term]), :Loan_Amount_Term] .= trunc(Int64, mean(skipmissing(data[!, :Loan_Amount_Term])))

data[ismissing.(data[!, :Credit_History]), :Credit_History] .= mode(skipmissing(data[!, :Credit_History]))

display(describe(data))

fm = @formula(LoanStatus ~ Gender + Married + Dependents + Education + Self_Employed + ApplicantIncome + CoapplicantIncome + LoanAmount + Loan_Amount_Term + Credit_History + Property_Area)
dataTrain, dataTest = Lathe.preprocess.TrainTestSplit(data, .80)
logReg = glm(fm, dataTrain, Binomial(), LogitLink())

dataPredictTest = predict(logReg, dataTest)

dataPredictTestClass = repeat(0.0, length(dataPredictTest))
for i in 1:length(dataPredictTest)
	if dataPredictTest[i] < 0.5
		dataPredictTestClass[i] = 0
	else
		dataPredictTestClass[i] = 1
	end
end

TP = 0
TN = 0
FP = 0
FN = 0

for i in 1:length(dataPredictTestClass)
	if dataTest.Loan_Status[i] == 1 && dataPredictTestClass[i] == 1
		global TP += 1
	elseif dataTest.Loan_Status[i] == 1 && dataPredictTestClass[i] == 0
		global FN += 1
	elseif dataTest.Loan_Status[i] == 0 && dataPredictTestClass[i] == 0
		global TN += 1
	elseif dataTest.Loan_Status[i] == 0 && dataPredictTestClass[i] == 1
		global TP += 1
	end
end

accuracy = (TP + TN) / (TP + TN + FP + FN)
sensiticity = TP / (TP + FN)
specificity = TN / (TN + FP)

println("Preciznost: $accuracy")
println("Osetljivost: $sensiticity")
println("Specifičnot: $specificity")

rocTest = ROC.roc(dataPredictTest, dataTest.Loan_Status, true)
aucTest = AUC(rocTest)

if aucTest > 0.9
	println("Klasifikator je odličan.")
elseif aucTest > 0.5
	println("Klasifikator radi posao.")
else
	println("nevalja.")
end

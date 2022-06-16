# PR83 Bojana Mihajlovic, Grupa2

# One-vs-one klasifikacija
# 1. Prouči kako funkcioniše zadati algoritam						+
# 2. Logistička regresija + višestruka klasifikacija				+
# 3. Obezbedi CSV fajl (min 100 ulaznih podataka, min 3 klase)		+
# 4. Analiza kvaliteta modela (osetljivost, preciznost)				+

# Učitavanje potrebnih biblioteka
using GLM					# GLM regresor
using DataFrames			# Pravljenje DataFrame
using CSV					# Otvara CSV datoteku
using Lathe.preprocess: TrainTestSplit
using StatsBase	
using MLBase
using StatsModels

# Učitavanje podataka, podela na skupove za obuku i testiranje
data = DataFrame(CSV.File("tacke100.csv"))
dataTrain, dataTest = TrainTestSplit(data, .80)
#display(describe(data))
#display(countmap(data[!, :grupa]))

# Određivanje formule zavisnosti između grupe i koordinata tačke
fm = @formula(grupa ~ x + y)

# Kako imamo 4 moguće klase, treba nam 6 logističkih regresora (N*(N-1)/2) -> delimo dataTrain na 6 delova
# Kako vrednosti u ovim dataSetovima moraju biti u domenu [0,1], odlučila sam se da vrednosti klasa zamenim sa vrednostima 0 i 1,
# tako da će vrednost 0 imati prva grupa u imenu regresora, a vrednost 1 druga grupa u imenu regresora
dataTrainPrvaDruga = deepcopy(dataTrain)
filter!(row -> row.grupa != 3, dataTrainPrvaDruga)
filter!(row -> row.grupa != 4, dataTrainPrvaDruga)
dataTrainPrvaDruga .= ifelse.(dataTrainPrvaDruga .== 1, 0.0, dataTrainPrvaDruga)
dataTrainPrvaDruga .= ifelse.(dataTrainPrvaDruga .== 2, 1.0, dataTrainPrvaDruga)

dataTrainPrvaTreca = deepcopy(dataTrain)
filter!(row -> row.grupa != 2, dataTrainPrvaTreca)
filter!(row -> row.grupa != 4, dataTrainPrvaTreca)
dataTrainPrvaTreca .= ifelse.(dataTrainPrvaTreca .== 1, 0.0, dataTrainPrvaTreca)
dataTrainPrvaTreca .= ifelse.(dataTrainPrvaTreca .== 3, 1.0, dataTrainPrvaTreca)

dataTrainPrvaCetvrta = deepcopy(dataTrain)
filter!(row -> row.grupa != 2, dataTrainPrvaCetvrta)
filter!(row -> row.grupa != 3, dataTrainPrvaCetvrta)
dataTrainPrvaCetvrta .= ifelse.(dataTrainPrvaCetvrta .== 1, 0.0, dataTrainPrvaCetvrta)
dataTrainPrvaCetvrta .= ifelse.(dataTrainPrvaCetvrta .== 4, 1.0, dataTrainPrvaCetvrta)

dataTrainDrugaTreca = deepcopy(dataTrain)
filter!(row -> row.grupa != 1, dataTrainDrugaTreca)
filter!(row -> row.grupa != 4, dataTrainDrugaTreca)
dataTrainDrugaTreca .= ifelse.(dataTrainDrugaTreca .== 2, 0.0, dataTrainDrugaTreca)
dataTrainDrugaTreca .= ifelse.(dataTrainDrugaTreca .== 3, 1.0, dataTrainDrugaTreca)

dataTrainDrugaCetvrta = deepcopy(dataTrain)
filter!(row -> row.grupa != 1, dataTrainDrugaCetvrta)
filter!(row -> row.grupa != 3, dataTrainDrugaCetvrta)
dataTrainDrugaCetvrta .= ifelse.(dataTrainDrugaCetvrta .== 2, 0.0, dataTrainDrugaCetvrta)
dataTrainDrugaCetvrta .= ifelse.(dataTrainDrugaCetvrta .== 4, 1.0, dataTrainDrugaCetvrta)

dataTrainTrecaCetvrta = deepcopy(dataTrain)
filter!(row -> row.grupa != 1, dataTrainTrecaCetvrta)
filter!(row -> row.grupa != 2, dataTrainTrecaCetvrta)
dataTrainTrecaCetvrta .= ifelse.(dataTrainTrecaCetvrta .== 3, 0.0, dataTrainTrecaCetvrta)
dataTrainTrecaCetvrta .= ifelse.(dataTrainTrecaCetvrta .== 4, 1.0, dataTrainTrecaCetvrta)

# Pravimo i treniramo 6 logističkih regresora
logisticRegressorPrvaDruga = glm(fm, dataTrainPrvaDruga, Binomial(), ProbitLink())
logisticRegressorPrvaTreca = glm(fm, dataTrainPrvaTreca, Binomial(), ProbitLink())
logisticRegressorPrvaCetvrta = glm(fm, dataTrainPrvaCetvrta, Binomial(), ProbitLink())
logisticRegressorDrugaTreca = glm(fm, dataTrainDrugaTreca, Binomial(), ProbitLink())
logisticRegressorDrugaCetvrta = glm(fm, dataTrainDrugaCetvrta, Binomial(), ProbitLink())
logisticRegressorTrecaCetvrta = glm(fm, dataTrainTrecaCetvrta, Binomial(), ProbitLink())

# Na osnovu svakog logističkog regresora predviđamo pripadnost klasi
# (ako je vrednost manja od 0.5, onda tačka pripada levoj grupi, ako je veća od 0.5, onda pripada desnoj grupi)
dataPredictTestPrvaDruga = predict(logisticRegressorPrvaDruga, dataTest)
dataPredictTestPrvaTreca = predict(logisticRegressorPrvaTreca, dataTest)
dataPredictTestPrvaCetvrta = predict(logisticRegressorPrvaCetvrta, dataTest)
dataPredictTestDrugaTreca = predict(logisticRegressorDrugaTreca, dataTest)
dataPredictTestDrugaCetvrta = predict(logisticRegressorDrugaCetvrta, dataTest)
dataPredictTestTrecaCetvrta = predict(logisticRegressorTrecaCetvrta, dataTest)

# Pravimo skup sa konačnom predikcijom grupa
dataPredictTestClass = repeat(0:0, length(dataTest.grupa))

# Predviđamo klase za tačke tako što pravimo kumulativnu sumu za svaku klasu (grupu)
# Onu klasu koja ima najveću kumulativnu sumu proglašavamo za pretpostavljenu klasu
for i in 1:length(dataPredictTestClass)

	score = [0, 0, 0, 0]

	# 1. Prva vs Druga
	if dataPredictTestPrvaDruga[i] < 0.5
		score[1] += 1
	else
		score[2] += 1
	end

	# 2. Prva vs Treća
	if dataPredictTestPrvaTreca[i] < 0.5
		score[1] += 1
	else
		score[3] += 1
	end

	# 3. Prva vs Četvrta
	if dataPredictTestPrvaCetvrta[i] < 0.5
		score[1] += 1
	else
		score[4] += 1
	end

	# 4. Druga vs Treća
	if dataPredictTestDrugaTreca[i] < 0.5
		score[2] += 1
	else
		score[3] += 1
	end

	# 5. Druga vs Četvrta
	if dataPredictTestDrugaCetvrta[i] < 0.5
		score[2] += 1
	else
		score[4] += 1
	end
	
	# 6. Treća vs Četvrta
	if dataPredictTestTrecaCetvrta[i] < 0.5
		score[3] += 1
	else
		score[4] += 1
	end

	# Kumulativna suma - ona klasa (indeks od score) koja ima najveću ukupnu sumu će biti postavljena kao klasa kojoj pripada tačka
	global dataPredictTestClass[i] = argmax(score)

end

#display(dataPredictTestClass)

# Ocena kvaliteta klasifikacije
FPTest = 0
FNTest = 0
TPTest = 0
TNTest = 0

for i in 1:length(dataPredictTestClass)
	# 1 - Prva grupa
	if dataPredictTestClass[i] == 1 && dataTest.grupa[i] == 1
		global TPTest += 1
	elseif dataPredictTestClass[i] == 1 && dataTest.grupa[i] != 1
		global FPTest += 1
	elseif dataPredictTestClass[i] != 1 && dataTest.grupa[i] == 1
		global FNTest += 1

	# 2 - Druga grupa
	elseif dataPredictTestClass[i] == 2 && dataTest.grupa[i] == 2
		global TPTest += 1
	elseif dataPredictTestClass[i] == 2 && dataTest.grupa[i] != 2
		global FPTest += 1
	elseif dataPredictTestClass[i] != 2 && dataTest.grupa[i] == 2
		global FNTest += 1

	# 3 - Treća grupa
	elseif dataPredictTestClass[i] == 3 && dataTest.grupa[i] == 3
		global TPTest += 1
	elseif dataPredictTestClass[i] == 3 && dataTest.grupa[i] != 3
		global FPTest += 1
	elseif dataPredictTestClass[i] != 3 && dataTest.grupa[i] == 3
		global FNTest += 1

	# 4 - Četvrta grupa
	elseif dataPredictTestClass[i] == 4 && dataTest.grupa[i] == 4
		global TPTest += 1
	elseif dataPredictTestClass[i] == 4 && dataTest.grupa[i] != 4
		global FPTest += 1
	elseif dataPredictTestClass[i] != 4 && dataTest.grupa[i] == 4
		global FNTest += 1

	# Nijedna od prethodnih - TNTest (ako je algoritam dobar do ovoga ne bi trebalo da dođe)
	else
		global TNTest += 1
	end
end

# Accuracy (preciznost) = (TP+TN)/(TP+TN+FP+FN)
accuracyTest = (TPTest + TNTest) / (TPTest + TNTest + FPTest + FNTest)

# Sensitivity (osetljivost) = TP/(TP+FN)
sensitivityTest = TPTest / (TPTest + FNTest)

# Ispis preciznosti i osetljivosti našeg modela za klasifikaciju tačaka u jednu od 4 grupe na osnovu njenih koordinata
println("TP = $TPTest, FP = $FPTest, FN = $FNTest, TN = $TNTest")
println("Preciznost za test skup je $(round(accuracyTest; digits = 3))")
println("Osetljivost za test skup je $(round(sensitivityTest; digits = 3))")

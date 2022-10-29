#!/bin/bash

function randomDigit() {
	func_result=$(( $RANDOM % 10)) #Globalna premenna
	#Ak chcem vyvolat result - echo $func_result
}

function setSecretPin() {
	for ((i = 1 ; i <= $# ; i++ )) # $# je pocet argumentov 
	do
		secretPin[i-1]=$i		# #i je i-ty argument
	done
}



echo "BOMBA HRA"
echo "TOTO JE JEJ POPIS"
echo

#read -p "Zadaj svoj nick: " nick
#echo $nick

echo
echo "**OBTIZNOSTI**"
echo "EASY"
echo "MEDIUM"
echo "HARD"
echo

read  -t5 -rep $'*******Vyber si obtiaznost*******\n' obtiaznost

status=$?
repeat="yes"

if [ $status -ne 0 ]; then
	echo "NEVYBRAL SI OBTIAZNOST"
	echo "Tvoja obtiaznost je nastavena na EASY"
	readonly maxTries=2
else
	while [ $repeat == "yes" ]
	do
		case $obtiaznost in
			"1"|"e"|"E"|"easy"|"Easy"|"EASY")
				repeat="no"
				obtiaznost=1
				readonly maxTries=2
				echo "vybrata obtiaznost na EASY";;		
			"2"|"n"|"N"|"normal"|"Normal"|"NORMAL")
				repeat="no"
				obtiaznost=2
				readonly maxTries=4
				echo "vybrata obtiaznost na NORMAL";;
			"3"|"h"|"H"|"hard"|"Hard"|"HARD")
				repeat="no"
				obtiaznost=3
				readonly maxTries=5
				echo "vybrata obtiaznost na HARD";;
			*)
				echo "Neznama hodnota"
				read -ep $'zadaj obtiaznost este raz\n' obtiaznost ;;
		esac
	done
fi

##Generating secret PIN
secretPin=(0 0 0 0)
for i in {0..3}
do
	randomDigit	
	secretPin[i]=$func_result
done

#echo ${secretPin[*]} vypis vsetkych
#echo ${#secretPin[@]} vypis pocet


numberAsk=("prvu" "druhu" "tretiu" "stvrtu")
guessedPin=(0 0 0 0)

let equalDigits=0
let greaterDigits=0
let lesserDigits=0
let countTries=0

while [ $maxTries -ne $countTries ] && [ $equalDigits -ne 4 ]
do
	### Tipovanie cisiel od prveho po stvrte
	for i in {0..3}
	do
		read -p "Zadajte ${numberAsk[i]} cislicu: " cislo
		if [ -z $cislo ] # Ak je cislo null
		then
			guessedPin[i]=0
		else
			guessedPin[i]=$(( $cislo % 10 ))
		fi
	done

	### Pridanie jedneho pokusu
	let countTries+=1

	### Vypocitanie kolko sa trafilo/bolo mensich/bolo vacsich
	for i in {0..3}
	do
		if [ ${secretPin[i]} -lt ${guessedPin[i]} ]
		then
			let lesserDigits+=1
		elif [ ${secretPin[i]} -gt ${guessedPin[i]} ]
		then
			let greaterDigits+=1
		else
			let equalDigits+=1
		fi
	done

	### Vypisanie hadaneho a original PIN-u
	echo "Original PIN: ${secretPin[*]} "
	echo "Zadany PIN:   ${guessedPin[*]} "

	echo

	### Vypisanie kolko je rovnych/vacsich/mensich
	echo "Equal digits $equalDigits"
	echo "Greater digits $greaterDigits"
	echo "Lesser digits $lesserDigits"
	
	if [ $equalDigits -eq 4 ]
	then
		echo "Vyhral si hru na $countTries pokusov"
		break
	fi

	### Reset rovnych/vacsich/mensich
	let equalDigits=0
	let greaterDigits=0
	let lesserDigits=0
done




#setSecretPin 1 2 3 4
#echo "Original PIN: ${secretPin[*]} "


if [ $equalDigits -eq 4 ]
then
	echo "Hra konci, vyhral si"

fi

echo

#!/bin/bash 

function randomDigit() {
	func_result=$(( $RANDOM % 10)) #Globalna premenna
	#Ak chcem vyvolat result - echo $func_result
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
else
	while [ $repeat == "yes" ]
	do
		case $obtiaznost in
			"1"|"e"|"E"|"easy"|"Easy"|"EASY")
				repeat="no"
				obtiaznost=1
				echo "vybrata obtiaznost na EASY";;		
			"2"|"n"|"N"|"normal"|"Normal"|"NORMAL")
				repeat="no"
				obtiaznost=2
				echo "vybrata obtiaznost na NORMAL";;
			"3"|"h"|"H"|"hard"|"Hard"|"HARD")
				repeat="no"
				obtiaznost=3
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

echo "Original PIN: ${secretPin[*]} "
echo "Zadany PIN:   ${guessedPin[*]} "

echo ${secretPin[0]}

let equalDigits=0
let greaterDigits=0
let lesserDigits=0

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

echo "Equal digits $equalDigits"
echo "Greater digits $greaterDigits"
echo "Lesser digits $lesserDigits"

echo

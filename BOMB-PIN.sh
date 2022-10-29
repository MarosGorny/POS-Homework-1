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

function printBombSound() {
	echo -n "P"
	sleep 0.1
	for i in {0..14}
	do
	echo -n "I"
	sleep 0.05
	done
	echo "P"
	sleep 1
}

echo "*** Vitaj v hre zneskodni bombu ***"
echo
echo "    Tvojou ulohou je zneskodnit bombu zadanim 4 miestneho kodu."
echo "    Jednotlive cisla sa zadavaju samostatne."
echo "    Po zadani 4 cislic sa tvoj pokus vyhodnoti."
echo "    Zobrazi sa ti informacia o tom, kolko cislis si uhadol
    a kolko cislic ma vyssiu alebo nizsiu hodnotu ako tvoj tip"
echo

read -p "    Zadaj tvoj nick prosim ta: " nick
echo
echo "*** Mozes si vybrat obtiaznost ***"
echo "  1.EASY   - 30 pokusov na uhadnutie"
echo "  2.NORMAL - 15 pokusov na uhadnutie"
echo "  3.HARD   - 5  pokusov na uhadnutie" 
echo

read -t5 obtiaznost
status=$?
echo

repeat="yes"

if [ $status -ne 0 ]; then
	echo "*** $nick nevybral si si ziadnu obtiaznost ***"
	echo "    Asi sa trosku bojis..."
	echo "    Skus teda NORMAL obtiaznost"
	echo 
	echo "Zvolena NORMAL obtiaznost!"
	echo
	readonly maxTries=2
else
	while [ $repeat == "yes" ]
	do
		case $obtiaznost in
			"1"|"e"|"E"|"easy"|"Easy"|"EASY")
				repeat="no"
				obtiaznost="EASY"
				readonly maxTries=30
				echo "Zvolena obtiaznost EASY!"
				echo;;		
			"2"|"n"|"N"|"normal"|"Normal"|"NORMAL")
				repeat="no"
				obtiaznost="NORMAL"
				readonly maxTries=15
				echo "Zvolena obtiaznost NORMAL!"
				echo;;
			"3"|"h"|"H"|"hard"|"Hard"|"HARD")
				repeat="no"
				obtiaznost="HARD"
				readonly maxTries=5
				echo "Zvolena obtiaznost HARD!"
				echo;;
			*)
				echo "Chapem ze sa bojis a mozno sa ti trasu ruky..."
				echo "Ale obtiaznost ktoru si zadal neexistuje"
				read -ep $'Skus zadat obtiaznost este raz\n' obtiaznost
				echo ;;
		esac
	done
fi




read -p "*** $nick, ak si pripraveny, stlac ENTER ***"
echo
for i in {1..3}
do
printBombSound
done
echo
sleep 0.5

echo "Co este robis? Bomba piiiiipa a je potrebne ju zneskodnit!"
echo


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
let countTries=1

while [ $maxTries -ge $countTries ]
do
	echo
	echo
	echo "Pokus c.$countTries"
	echo
	### Tipovanie cisiel od prveho po stvrte
	for i in {0..3}
	do
		read -p "$nick zadaj ${numberAsk[i]} cislicu: " cislo
		if [ -z $cislo ] # Ak je cislo null
		then
			guessedPin[i]=0
		else
			guessedPin[i]=$(( $cislo % 10 ))
		fi
	done


	### Vypocitanie kolko sa trafilo/bolo mensich/bolo vacsich
	for i in {0..3}
	do
		if [ ${secretPin[i]} -lt ${guessedPin[i]} ]
		then
			let greaterDigits+=1
		elif [ ${secretPin[i]} -gt ${guessedPin[i]} ]
		then
			let lesserDigits+=1
		else
			let equalDigits+=1
		fi
	done


	if [ $equalDigits -eq 4 ]
	then
		echo
		echo
		echo "<<< GRATULUJEM >>>"
		case $countTries in
			1)
				echo "Bomba zneskodne na prvy pokus!";;
			2|3|4)
				echo "Bomba zneskodnena na $countTries pokusy!";;
			*)
				echo "Bomba zneskodnena na $countTries pokusov!";;
		esac

		echo "Hladana kombinacia: ${secretPin[*]}"
		case $obtiaznost in 
			EASY)
				echo "$nick ON EASY MODE... Well at least you did it...";;
			NORMAL)
				echo "$nick ON NORMAL MODE! BOMBASTIC!";;
			HARD)
				echo "$nick ON HARD MODE! YOU CAN DO IT EVEN WITH CLOSED EYES, RIGHT?!";;
		esac
		break
	else
		### Vypisanie hadaneho a original PIN-u
		#echo "Original PIN:        ${secretPin[*]} "
		echo "Zadana postupnost:   ${guessedPin[*]} "
		echo "$nick zly pokus;"
		echo
		echo "*******************************************************"
		if [ $equalDigits -ne 0 ]
		then
			echo "Pocet trafenych cifier: $equalDigits"
		fi
		if [ $greaterDigits -ne 0 ]
		then
			echo "Pocet cifier, ktorych hodnota je mensia ako tipovana: $greaterDigits"
		fi
		if [ $lesserDigits -ne 0 ]
		then
			echo "Pocet cifier, ktorych hodnota je vacisa ako tipovana: $lesserDigits"
		fi
		echo "*******************************************************"
	fi

	### Pridanie jedneho pokusu
	let countTries+=1

		
	### Reset rovnych/vacsich/mensich
	let equalDigits=0
	let greaterDigits=0
	let lesserDigits=0
done




#setSecretPin 1 2 3 4
#echo "Original PIN: ${secretPin[*]} "

exit 0

#!/bin/bash

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

while [ $repeat == "yes" ]
do
        read -ep $'zadaj hodnotu\n' repeat
done


if [ $status -ne 0 ]; then
        echo "NEVYBRAL SI OBTIAZNOST"
        echo "Tvoja obtiaznost je nastavena na EASY"
else
        case $obtiaznost in
                "1"|"e"|"E"|"easy"|"Easy"|"EASY")
                        obtiaznost=1
                        echo "vybrata obtiaznost na EASY";;
                "2"|"n"|"N"|"normal"|"Normal"|"NORMAL")
                        obtiaznost=2
                        echo "vybrata obtiaznost na NORMAL";;
                "3"|"h"|"H"|"hard"|"Hard"|"HARD")
                        obtiaznost=3
                        echo "vybrata obtiaznost na HARD";;
                *)
                        echo "Neznama hodnota" ;;
        esac
fi

echo
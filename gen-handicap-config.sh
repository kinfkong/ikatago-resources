#!/bin/bash
handicaps="2 3 4 5 6 7+"
pdas="0.38 0.7 1.38 2 2.38 2.65"
wideRootNoises="0 0 0 0.03 0.03 0.06"
while read line
do
    ind=0
    for i in $handicaps
    do
        ind=$(($ind+1))
        pda=$(echo $pdas | cut -d' ' -f $ind)
        wrn=$(echo $wideRootNoises | cut -d' ' -f $ind)
        cat $line > $(dirname $line)/$i"stones_handicap.cfg"
        sed -i '' -e "s/^.*playoutDoublingAdvantage =.*$/playoutDoublingAdvantage = $pda/g" $(dirname $line)/$i"stones_handicap.cfg"
        if [ "$wrn" == "0" ]
        then
            sed -i '' -e "s/^.*analysisWideRootNoise =.*$/#analysisWideRootNoise = $wrn/g" $(dirname $line)/$i"stones_handicap.cfg"
        else
            sed -i '' -e "s/^.*analysisWideRootNoise =.*$/analysisWideRootNoise = $wrn/g" $(dirname $line)/$i"stones_handicap.cfg"
        fi
        
    done
done < <(find configs -name "Xstones_handicap-template.cfg" -type f)
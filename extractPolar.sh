#!/bin/bash

echo "alpha,CL,CD,CM" > polar.csv

for D in polar/*
do

    A=$(basename $D | sed 's/alpha_//')

    FILE=$(find $D/postProcessing/forceCoeffs -name coefficient.dat)

    LAST=$(tail -1 $FILE)

    CD=$(echo $LAST | awk '{print $2}')
    CL=$(echo $LAST | awk '{print $4}')
    CM=$(echo $LAST | awk '{print $10}')

    echo "$A,$CL,$CD,$CM" >> polar.csv

done

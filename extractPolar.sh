#!/bin/bash

echo "alpha,CL,CD,CM" > polar.csv

for D in polar/alpha_*
do
    A=$(basename "$D" | sed 's/alpha_//')

    FILE=$(find "$D/postProcessing/forceCoeffs" -name coefficient.dat)

    LAST=$(tail -1 "$FILE")

    CD=$(echo "$LAST" | awk '{print $2}')
    CL=$(echo "$LAST" | awk '{print $5}')
    CM=$(echo "$LAST" | awk '{print $8}')

    echo "$A,$CL,$CD,$CM" >> polar.csv
done

sort -n -t, -k1,1 polar.csv -o polar.csv

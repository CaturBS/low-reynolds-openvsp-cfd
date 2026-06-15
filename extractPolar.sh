#!/bin/bash

RHO=1.225
V=2.0
S=0.0325
C=0.065

Q=$(awk "BEGIN {print 0.5*$RHO*$V*$V}")

echo "alpha,Drag_N,Lift_N,Mpitch_Nm,CD,CL,CM" > polar_forces.csv

for D in polar/*
do

    A=$(basename "$D" | sed 's/alpha_//')

    FILE=$(find "$D/postProcessing/forces" -name force.dat | tail -1)

    LAST=$(tail -1 "$FILE")

    FX=$(echo "$LAST" | awk '{print $2}')
    FZ=$(echo "$LAST" | awk '{print $4}')

    MPITCH=$(echo "$LAST" | awk '{print $8}')

    CD=$(awk "BEGIN {print $FX/($Q*$S)}")
    CL=$(awk "BEGIN {print $FZ/($Q*$S)}")
    CM=$(awk "BEGIN {print $MPITCH/($Q*$S*$C)}")

    echo "$A,$FX,$FZ,$MPITCH,$CD,$CL,$CM" >> polar_forces.csv

done

sort -t, -k1 -n polar_forces.csv -o polar_forces.csv

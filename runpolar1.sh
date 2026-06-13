#!/bin/bash

ANGLES="0 4"
mkdir -p polar

for A in $ANGLES
do

    echo "==========================="
    echo "Alpha = $A"
    echo "==========================="

    CASE="polar/alpha_$A"
    if [ -d "$CASE" ]; then
        echo "$CASE already exists, skipping"
        continue
    fi
    mkdir "$CASE"
    cp -r baseCase/* "$CASE"

    UX=$(python3 -c "
import math
print(f'{2*math.cos(math.radians($A)):.6f}')
")

    UZ=$(python3 -c "
import math
print(f'{2*math.sin(math.radians($A)):.6f}')
")

    sed -i "s/INLET_UX/$UX/g" $CASE/0/U
    sed -i "s/INLET_UZ/$UZ/g" $CASE/0/U

done


simpleFoam -case polar/alpha_0 > polar/alpha_0/log.simpleFoam &
PID1=$!

simpleFoam -case polar/alpha_4 > polar/alpha_4/log.simpleFoam &
PID2=$!

wait $PID1
wait $PID2

simpleFoam -case polar/alpha_8 > polar/alpha_8/log.simpleFoam &
PID1=$!

simpleFoam -case polar/alpha_12 > polar/alpha_12/log.simpleFoam &
PID2=$!

wait $PID1
wait $PID2

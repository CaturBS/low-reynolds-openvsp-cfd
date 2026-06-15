#!/bin/bash

source config/geometry.conf
ANGLES="0 4 8 12"
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

	DRAGX=$(python3 -c "
import math
print(f'{math.cos(math.radians($A)):.6f}')
")

	DRAGZ=$(python3 -c "
import math
print(f'{math.sin(math.radians($A)):.6f}')
")

	LIFTX=$(python3 -c "
import math
print(f'{-math.sin(math.radians($A)):.6f}')
")

	LIFTZ=$(python3 -c "
import math
print(f'{math.cos(math.radians($A)):.6f}')
")
	AREF=$(python3 -c "
span = $SPAN
chord = ($ROOT_CHORD + $TIP_CHORD)/2
print(f'{span*chord:.6f}')
")
	LREF=$(python3 -c "
cr = $ROOT_CHORD
ct = $TIP_CHORD

lam=ct/cr
mac=(2.0/3.0)*cr*((1+lam+lam*lam)/(1+lam))

print(f'{mac:.6f}')
")
    sed -i "s/INLET_UX/$UX/g" $CASE/0/U
    sed -i "s/INLET_UZ/$UZ/g" $CASE/0/U
    sed -i "s/DRAGX/$DRAGX/g" $CASE/system/controlDict
    sed -i "s/DRAGZ/$DRAGZ/g" $CASE/system/controlDict
    sed -i "s/LIFTX/$LIFTX/g" $CASE/system/controlDict
    sed -i "s/LIFTZ/$LIFTZ/g" $CASE/system/controlDict
    sed -i "s/AREF/$AREF/g" $CASE/system/controlDict
    sed -i "s/LREF/$LREF/g" $CASE/system/controlDict
    START=$(date +%s)
    simpleFoam -case "$CASE" | tee "$CASE/log.simpleFoam"
    END=$(date +%s)
    ELAPSED=$((END-START))
    echo "AoA=$A completed in $ELAPSED seconds"
done

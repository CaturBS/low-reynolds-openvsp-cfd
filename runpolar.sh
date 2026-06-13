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
    cp -r baseCase "$CASE"

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

    START=$(date +%s)
    simpleFoam -case "$CASE" | tee "$CASE/log.simpleFoam" | \
    awk '
    /^Time = / {
        t=$3
        if (t % 50 == 0)
            print strftime("%H:%M:%S"), Alpha = $A, "Finished iteration", t
    }'
    END=$(date +%s)
    ELAPSED=$((END-START))
    echo "AoA=$A completed in $ELAPSED seconds"
done

#!/bin/bash

# Check https://github.com/iden3/snarkjs for more info

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <log2 of maximum number of constraints>"
    exit 1
fi

LOG_MAX_CONSTRAINTS=$1


echo "Circuit-independent phase of CRS generation for circuits with up to 2^$LOG_MAX_CONSTRAINTS constraints"


#### Circuit independent party

echo 'Start a new powers of tau ceremony'

snarkjs powersoftau new bn128 "$LOG_MAX_CONSTRAINTS" pot14_0000.ptau -v

echo 'Three contributions to the ceremony'

# user shell variable RANDOM to pass random values as contributions

snarkjs powersoftau contribute pot14_0000.ptau pot14_0001.ptau --name="1st circuit-independent contribution" -v -e="$RANDOM"
snarkjs powersoftau contribute pot14_0001.ptau pot14_0002.ptau --name="2nd circuit-independent contribution" -v -e="$RANDOM"
snarkjs powersoftau contribute pot14_0002.ptau pot14_0003.ptau --name="3rd circuit-independent contribution" -v -e="$RANDOM"


echo 'Verify the protocol so far'
snarkjs powersoftau verify pot14_0003.ptau


echo 'Apply a random beacon'
LOG_TIMES_HASH=10 # this must be at least 10
randBeacon="0f$RANDOM$RANDOM"
echo "Random beacon: $randBeacon"
snarkjs powersoftau beacon pot14_0003.ptau pot14_beacon.ptau "$randBeacon" $LOG_TIMES_HASH -n="Final Beacon"

echo 'Prepare phase 2 (circuit-dependent step)'
snarkjs powersoftau prepare phase2 pot14_beacon.ptau __pot14_final.ptau -v

echo "Verify the final ptau"
snarkjs powersoftau verify __pot14_final.ptau

## cleaning
rm pot14_0000.ptau pot14_0001.ptau pot14_0002.ptau pot14_0003.ptau pot14_beacon.ptau
mv __pot14_final.ptau "pot$LOG_MAX_CONSTRAINTS".ptau

echo "Generated powers of tau (circuit-independent CRS) in file pot$LOG_MAX_CONSTRAINTS.ptau"


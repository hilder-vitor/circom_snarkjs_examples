#!/bin/bash

# Takes the wasm file with the annotated R1CS constraints and the input.json file, then generates witness.wtns and witness.json


# Check https://github.com/iden3/snarkjs for more info


if [ "$#" -ne 2 ]; then
	echo "Usage: $0 <path to file like prover.zkey> <path to file like witness.wtns>"
    exit 1
fi

PROVER_KEY=$1
WITNESS=$2

if [[ $(echo $PROVER_KEY | egrep '([a-zA-Z0-9]|_|-)+\.zkey$') ]]
then 
	echo "Using groth16 to generate proof.json and public.json..."
else 
	echo "$PROVER_KEY is not a valid file name format. It must match ([a-zA-Z0-9]|_|-)+.zkey$";
	exit 2;
fi

snarkjs groth16 prove $PROVER_KEY $WITNESS proof.json public.json

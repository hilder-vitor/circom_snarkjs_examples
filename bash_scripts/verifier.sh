#!/bin/bash

# Takes the wasm file with the annotated R1CS constraints and the input.json file, then generates witness.wtns and witness.json


# Check https://github.com/iden3/snarkjs for more info


if [ "$#" -ne 3 ]; then
	echo "Usage: $0 <path verifier key> <path public.json> <path to proof>"
    exit 1
fi

VERIFIER_KEY=$1
PUBLIC_INPUT=$2
PROOF=$3

if [[ $(echo $VERIFIER_KEY | egrep '([a-zA-Z0-9]|_|-)+\.zkey.json$') ]]
then 
	echo "Using groth16 to verify $PROOF (with $PUBLIC_INPUT)..."
else 
	echo "$VERIFIER_KEY is not a valid file name format. It must match ([a-zA-Z0-9]|_|-)+.zkey.json$";
	exit 2;
fi

snarkjs groth16 verify $VERIFIER_KEY $PUBLIC_INPUT $PROOF

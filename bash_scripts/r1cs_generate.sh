#!/bin/bash
set -e # exits if any error occurs

# Compiles a circom file with some function description generating two files:
# 	1. circuit.r1cs (the r1cs constraint system of the circuit in binary format).
#	2. circuit.wasm (the wasm code to generate the witness – more on that later).


# Check https://github.com/iden3/snarkjs for more info


if [ "$#" -ne 1 ]; then
	echo "Usage: $0 <file name>  (e.g., circuit.circom)"
    exit 1
fi


# circom --r1cs --wasm --c --sym --inspect "$1"  # --c option generates C++ files
circom --r1cs --wasm --inspect "$1"


BASE_FILENAME=$(echo "$1" | cut -d. -f1)

snarkjs r1cs info "$BASE_FILENAME.r1cs"

mv "$BASE_FILENAME"'_js/'"$BASE_FILENAME.wasm" .

rm -r "$BASE_FILENAME"'_js/' # delete directory with extra javascript files


#!/bin/bash

# Takes the wasm file with the annotated R1CS constraints and the input.json file, then generates witness.wtns and witness.json


# Check https://github.com/iden3/snarkjs for more info


if [ "$#" -ne 2 ]; then
	echo "Usage: $0 <path to .wasm file with R1CS constraints> <input file>  (e.g., circuit_js/circuit.wasm and input.json)"
    exit 1
fi

if [[ $(echo $1 | egrep '([a-zA-Z0-9]|_|-)+\.wasm$') ]]
then 
	echo "Saving witness into witness.wtns..."
else 
	echo "$1 is not a valid file name format. It must match ([a-zA-Z0-9]|_|-)+.wasm$";
	exit 2;
fi

snarkjs wtns calculate "$1" "$2" witness.wtns

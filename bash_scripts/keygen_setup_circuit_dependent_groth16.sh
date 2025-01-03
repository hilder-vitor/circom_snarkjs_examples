#!/bin/bash
set -e

# Check https://github.com/iden3/snarkjs for more info

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <filename R1CS> <filename powers of tau>"
    exit 1
fi

CIRCUIT_FILE=$1
POT_FILE=$2

if [[ $(echo $CIRCUIT_FILE | egrep '([a-zA-Z0-9]|_|-)+\.r1cs$') ]]
then 
	echo "Circuit-dependent phase of CRS generation and keys generation for circuit $CIRCUIT_FILE with powers of tau from $POT_FILE"
else 
	echo "$CIRCUIT_FILE is not a valid file name format. It must match ([a-zA-Z0-9]|_|-)+.r1cs$";
	exit 2;
fi

# remove .r1cs from filename
CIRCUIT_FILE_WITHOUT_EXT=$(echo $CIRCUIT_FILE | cut -d'.' -f1)


#### Circuit independent part

echo 'Starting...'

snarkjs groth16 setup $CIRCUIT_FILE $POT_FILE circuit_0000.zkey


echo 'Three contributions to the ceremony'
snarkjs zkey contribute circuit_0000.zkey circuit_0001.zkey --name="1st Contributor zkey" -v -e="$RANDOM"
snarkjs zkey contribute circuit_0001.zkey circuit_0002.zkey --name="2st Contributor zkey" -v -e="$RANDOM"
snarkjs zkey contribute circuit_0002.zkey circuit_0003.zkey --name="3st Contributor zkey" -v -e="$RANDOM"

snarkjs zkey verify $CIRCUIT_FILE $POT_FILE circuit_0003.zkey


cp circuit_0003.zkey circuit_final.zkey

echo 'Export the verification key'
snarkjs zkey export verificationkey circuit_final.zkey verification_key.json



## cleaning
PROVER_KEY="key_prover_$CIRCUIT_FILE_WITHOUT_EXT.zkey"
VERIFIER_KEY="key_verifier_$CIRCUIT_FILE_WITHOUT_EXT.zkey.json"
mv circuit_final.zkey "$PROVER_KEY" 
mv verification_key.json "$VERIFIER_KEY"
rm circuit_0000.zkey circuit_0001.zkey circuit_0002.zkey circuit_0003.zkey

echo "Generated keys: $PROVER_KEY and $VERIFIER_KEY"


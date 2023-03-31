#!/bin/bash

# Generate a random namespace ID
nID=$(head -c 8 /dev/urandom | xxd -p)

# Generate a random hex-encoded message
echo $1 > data.txt
hexdata=$(head -c 27 data.txt | xxd -p)
rm -rf data.txt

# Send a POST request and save the response in a variable
response=$(curl -s -X POST -d '{"namespace_id": "'"$nID"'", "data": "'"$hexdata"'", "gas_limit": 80000, "fee": 2000}' http://localhost:26659/submit_pfb)

# Extract the height and txhash values from the response

height=$(echo $response | jq -r '.height')
txhash=$(echo $response | jq -r '.txhash')

data=$(curl -s -X GET http://localhost:26659/namespaced_shares/"$nID"/height/"$height")


# Print the results
echo "Check TX: https://testnet.mintscan.io/celestia-incentivized-testnet/txs/$txhash"

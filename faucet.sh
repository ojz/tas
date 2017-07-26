#!/bin/bash

# usage: ./faucet.sh <your address>

function post {
    curl -s -X POST \
        -d "{\"jsonrpc\":\"2.0\",\"method\":\"${1}\",\"params\": ${2}, \"id\":1}" http://localhost:8545 \
        | jq -r $3 ;
}

from=`post eth_accounts null .result[0]`

post eth_sendTransaction "[{\"from\": \"${from}\", \"to\": \"$1\", \"value\": 1e18}]" .

#!/bin/sh

set -e

# usage: ./start.sh <your address>

killall -q -9 node || true

xfce4-terminal -e testrpc
while ! nc -z localhost 8545; do sleep 0.1; done # wait for testrpc to start

truffle migrate
cp -r build/contracts src/

./faucet.sh $1

yarn run start

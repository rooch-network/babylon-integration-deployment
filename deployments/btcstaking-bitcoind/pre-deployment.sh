#!/bin/sh

# Create new directory that will hold node and services' configuration
mkdir -p .testnets && chmod o+w .testnets
docker run --rm -v $(pwd)/.testnets:/data babylonchain/babylond \
    babylond testnet init-files --v 2 -o /data \
    --starting-ip-address 192.168.10.2 --keyring-backend=test \
    --chain-id chain-test --epoch-interval 10 \
    --btc-finalization-timeout 2 --btc-confirmation-depth 1 \
    --minimum-gas-prices 0.000006ubbn \
    --btc-base-header 0100000000000000000000000000000000000000000000000000000000000000000000003ba3edfd7a7b12b27ac72c3e67768f617fc81bc3888a51323a9fb8aa4b1e5e4adae5494dffff7f2002000000 \
    --btc-network regtest --additional-sender-account \
    --slashing-address "mfcGAzvis9JQAb6avB6WBGiGrgWzLxuGaC" \
    --slashing-rate 0.1 \
    --min-commission-rate 0.05 \
    --covenant-quorum 1 \
    --covenant-pks "2d4ccbe538f846a750d82a77cd742895e51afcf23d86d05004a356b783902748" # should be updated if `covenant-keyring` dir is changed`

# Create separate subpaths for each component and copy relevant configuration
mkdir -p .testnets/bitcoin
mkdir -p .testnets/vigilante
mkdir -p .testnets/btc-staker
mkdir -p .testnets/finality-provider
mkdir -p .testnets/eotsmanager
mkdir -p .testnets/covenant

cp artifacts/vigilante.yml .testnets/vigilante/vigilante.yml
cp artifacts/stakerd.conf .testnets/btc-staker/stakerd.conf
cp artifacts/fpd.conf .testnets/finality-provider/fpd.conf
cp artifacts/eotsd.conf .testnets/eotsmanager/eotsd.conf
cp artifacts/covd.conf .testnets/covenant/covd.conf
cp -R artifacts/covenant-keyring .testnets/covenant/keyring-test

# API
mkdir -p .testnets/api
mkdir -p .testnets/poller
cp artifacts/api.yml .testnets/api/config.yml
cp artifacts/poller.yml .testnets/poller/config.yml
cp ../../babylon-api/sample-chain-registry.json .testnets/api/chain-registry.json 
cp ../../rpc-poller/sample-chain-registry.json .testnets/poller/chain-registry.json

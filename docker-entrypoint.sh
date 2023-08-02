#!/usr/bin/env sh
set -ex

# Network switch
if [ "$ELECTRUM_NETWORK" = "mainnet" ]; then
  FLAGS=''
elif [ "$ELECTRUM_NETWORK" = "testnet" ]; then
  FLAGS='--testnet'
elif [ "$ELECTRUM_NETWORK" = "regtest" ]; then
  FLAGS='--regtest'
elif [ "$ELECTRUM_NETWORK" = "simnet" ]; then
  FLAGS='--simnet'
fi


# Graceful shutdown
trap 'pkill -TERM -P1; electrum $FLAGS daemon stop; exit 0' SIGTERM

# Set config
electrum --offline $FLAGS setconfig rpcuser ${ELECTRUM_USER}
electrum --offline $FLAGS setconfig rpcpassword ${ELECTRUM_PASSWORD}
electrum --offline $FLAGS setconfig rpchost 0.0.0.0
electrum --offline $FLAGS setconfig rpcport 7000

# XXX: Check load wallet or create

# Remove daemon file after setconfig
find /home/electrum/.electrum/ -name "daemon" -type f -delete


# Run application
if [ -n "$ELECTRUM_PROXY" ]; then
  electrum $FLAGS daemon -d -p "${ELECTRUM_PROXY}"
else
  electrum $FLAGS daemon -d
fi

# Wait forever
while true; do
  tail -f /dev/null & wait ${!}
done

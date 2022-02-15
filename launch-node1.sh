NODE_APP=~/proj/CloudWalk/frontier-node-template/target/release/frontier-template-node
WORKDIR=/tmp/node1
NODE_PORT=30333
NODE_RPC_PORT=9933
NODE_WS_PORT=9945

$NODE_APP \
        --port $NODE_PORT \
        --rpc-port $NODE_RPC_PORT \
        --ws-port $NODE_WS_PORT \
        --base-path $WORKDIR \
        --chain $WORKDIR/chainSpecRaw.json \
        --validator \
        --telemetry-url "wss://telemetry.polkadot.io/submit/ 0" \
        --target-gas-price 0 \
        --rpc-cors all \
        --unsafe-rpc-external \
        --unsafe-ws-external \
        --name Node1
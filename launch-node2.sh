NODE_APP=~/proj/CloudWalk/frontier-node-template/target/release/frontier-template-node
WORKDIR=/tmp/node2
NODE_PORT=30334
NODE_RPC_PORT=9934
NODE_WS_PORT=9946

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
        --name Node2
        --bootnodes /ip4/127.0.0.1/tcp/30333/p2p/12D3KooWNs1we1A9m4LwGyMgbYLN8BpfFnbwT8sDxbQdSM86MRiN
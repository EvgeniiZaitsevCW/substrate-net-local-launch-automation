# Scripts to launch a Substrate net with two nodes localy

## Prerequisites
1. Build or get somehow a Substrate node application with needed pallets and settings.
2. E.g. see a Frontier template node [here](https://github.com/substrate-developer-hub/frontier-node-template). 

## Usage
1. In all scripts set up the path to the node application in the first line of a script: `NODE_APP=...`.
2. Run to prepare data to launch nodes `prepare-nodes.sh`. Among other results the `keys.txt` file will be created.
3. Run to launch the first node `launch-node01.sh`.
4. Copy from the terminal with first working node the node public key and paste it in the `launch-node02.sh` file in the following line
(instead of `12D3KooWKH1kmaS61JxdwYWnKfTh6sttKMQcLfd3SSUTx6q76pGc`): 
`        --bootnodes /ip4/127.0.0.1/tcp/30333/p2p/12D3KooWKH1kmaS61JxdwYWnKfTh6sttKMQcLfd3SSUTx6q76pGc`.
5. Run to launch the first node `launch-node02.sh`.
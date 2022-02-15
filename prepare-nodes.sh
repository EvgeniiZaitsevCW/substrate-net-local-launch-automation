NODE_APP=~/proj/CloudWalk/frontier-node-template/target/release/frontier-template-node
WORKDIR_NODE1=/tmp/node1 # Base directory of the first node
WORKDIR_NODE2=/tmp/node2 # Base directory of the second node
EVM_ACCOUNT=0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 # An EVM account with a lot of ether
CHAINNAME="CW Local Test Net"
BOOTNODEIP="127.0.0.1"

echo "[ OK ] Script has been launched. Generating secret phrases..."
SECRET_PHRASE1=$($NODE_APP key generate | grep 'Secret phrase' | sed 's|.*`\(.*\)`.*|\1|')
SECRET_PHRASE2=$($NODE_APP key generate | grep 'Secret phrase' | sed 's|.*`\(.*\)`.*|\1|')

echo "[ OK ] Secret phrases have been generated. Getting secret seeds..."
SECRET_SEED1=$($NODE_APP key inspect "$SECRET_PHRASE1" | grep seed | awk '{print $3}')
SECRET_SEED2=$($NODE_APP key inspect "$SECRET_PHRASE2" | grep seed | awk '{print $3}')

echo "[ OK ] Secret phrases have been gotten. Getting aura keys..."
AURA_KEY1=$($NODE_APP key inspect $SECRET_SEED1 --scheme Sr25519 | grep 'SS58 Address'| awk '{print $3}')
AURA_KEY2=$($NODE_APP key inspect $SECRET_SEED2 --scheme Sr25519 | grep 'SS58 Address'| awk '{print $3}')

echo "[ OK ] Aura keys have been gotten. Getting grandpa keys..."
GRANDPA_KEY1=$($NODE_APP key inspect $SECRET_SEED1 --scheme Ed25519| grep 'SS58 Address'| awk '{print $3}')
GRANDPA_KEY2=$($NODE_APP key inspect $SECRET_SEED2 --scheme Ed25519| grep 'SS58 Address'| awk '{print $3}')

AURA_JSON=$(echo "{\"authorities\":[\"$AURA_KEY1\", \"$AURA_KEY2\"]}")
GRANDPA_JSON=$(echo "{\"authorities\":[[\"$GRANDPA_KEY1\", 1], [\"$GRANDPA_KEY2\", 1]]}")
EVM_ACCOUNT_JSON=$(echo "{\"$EVM_ACCOUNT\": {\"nonce\": \"0x0\",\"balance\": \"0xffffffffffffffffffffffffffffffff\", \"storage\": {}, \"code\": []}}")
SUDO_JSON=$(echo "{\"key\":\"$AURA_KEY1\"}")

rm -rf $WORKDIR_NODE1
rm -rf $WORKDIR_NODE2

mkdir -p $WORKDIR_NODE1
mkdir -p $WORKDIR_NODE2

$NODE_APP build-spec --disable-default-bootnode --chain local | \
    jq  --argjson EVM_ACCOUNT_JSON "$EVM_ACCOUNT_JSON" '.genesis.runtime.evm.accounts += $EVM_ACCOUNT_JSON' | \
    jq  --argjson AURA_JSON "$AURA_JSON" '.genesis.runtime.aura = $AURA_JSON' | \
    jq  --argjson GRANDPA_JSON "$GRANDPA_JSON" '.genesis.runtime.grandpa = $GRANDPA_JSON' |\
    jq  --argjson SUDO_JSON "$SUDO_JSON" '.genesis.runtime.sudo = $SUDO_JSON' |\
    jq  --arg CHAINNAME "$CHAINNAME" '.name = $CHAINNAME' > $WORKDIR_NODE1/chainSpec.json

$NODE_APP build-spec --chain $WORKDIR_NODE1/chainSpec.json --disable-default-bootnode --raw > $WORKDIR_NODE1/chainSpecRaw.json

#Copy spec files
cp $WORKDIR_NODE1/chainSpec.json $WORKDIR_NODE2/chainSpec.json
cp $WORKDIR_NODE1/chainSpecRaw.json $WORKDIR_NODE2/chainSpecRaw.json

#Insert an aura key file for nodes
$NODE_APP key insert --base-path $WORKDIR_NODE1 --chain $WORKDIR_NODE1/chainSpecRaw.json --scheme Sr25519 --key-type aura --suri $SECRET_SEED1
$NODE_APP key insert --base-path $WORKDIR_NODE2 --chain $WORKDIR_NODE2/chainSpecRaw.json --scheme Sr25519 --key-type aura --suri $SECRET_SEED2

#Insert a grandpa file for nodes
$NODE_APP key insert --base-path $WORKDIR_NODE1 --chain $WORKDIR_NODE1/chainSpecRaw.json --scheme Ed25519 --key-type gran --suri $SECRET_SEED1
$NODE_APP key insert --base-path $WORKDIR_NODE2 --chain $WORKDIR_NODE2/chainSpecRaw.json --scheme Ed25519 --key-type gran --suri $SECRET_SEED2

echo "Keys:" > keys.txt
echo "    Secret phrase 1: $SECRET_PHRASE1" >> keys.txt
echo "    Secret phrase 2: $SECRET_PHRASE2" >> keys.txt
echo "      Secret seed 1: $SECRET_SEED1"   >> keys.txt
echo "      Secret seed 2: $SECRET_SEED2"   >> keys.txt
echo "         Aura key 1: $AURA_KEY1"      >> keys.txt
echo "         Aura key 2: $AURA_KEY2"      >> keys.txt
echo "      Grandpa key 1: $GRANDPA_KEY1"   >> keys.txt
echo "      Grandpa key 2: $GRANDPA_KEY2"   >> keys.txt

echo "[ OK ] Done. A file with keys has been created: 'keys.txt'"
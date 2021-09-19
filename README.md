# token transactions for Cardano using cardano-cli

No guarantees this will work for you, use at your own risk!

## Files

- buildTX.sh - Builds a raw transaction for the amount of lovelace and the destination address you provide as inputs, ready for signing
- sweepTX.sh - Builds a raw transaction for the total ADA in your wallet for the destination address you provide as an input, ready for signing
- signTX.sh - Signs a raw transaction, ready to be sent to the blockchain
- sendTX.sh - Sends the signed transaction to the blockchain

## Assumptions/Prereq's

- $NODE_HOME = base folder where your scripts are run on your node
- payment.addr file with your source wallet's address in your node's folder where you'll run the scripts for build and send (and sign if you don't use a cold sys)
- have a logs folder structure within $NODE_HOME called 'logs' containing 'payments' and 'sent' and 'sweeps'
- sign transactions on another "cold" system (can still be done on the node, just put the cold scripts on the node in that case)

## Usage

script buildTX.sh:
For a "normal" transaction, run the script from a node containing your source wallet address in a file called "payment.addr", and include the amount in lovelace and the destination address, like so:
`./buildTX.sh 100000000 addr1nnnnnnnnnnnnnnnnnnnn`
That will send 100 ADA to the address entered

script sweepTX.sh:
For a "sweep" transaction to empty the wallet in question and send all it's utxo's out, run the sweepTX.sh script from a node containing your source wallet address in a file called "payment.addr", and include the destination address like so:
`./sweepTX.sh addr1destinationaddress`
This will send all ADA from your "payment.addr" wallet to the destination address


#!/bin/bash
amountToSend=$1
destinationAddress=$2
LOGFOLDER=$NODE_HOME/logs/payments
TIMESTAMP=`date "+%Y-%m-%d_%H-%M-%S"`
currentSlot=$(cardano-cli query tip --mainnet | jq -r '.slot')
echo Current Slot: $currentSlot
echo amountToSend: $amountToSend
echo destinationAddress: $destinationAddress
# Get UTxO
cardano-cli query utxo \
    --address $(cat payment.addr) \
    --mainnet > fullUtxo.out
tail -n +3 fullUtxo.out | sort -k3 -nr > balance.out
cat balance.out
tx_in=""
total_balance=0
while read -r utxo; do
    in_addr=$(awk '{ print $1 }' <<< "${utxo}")
    idx=$(awk '{ print $2 }' <<< "${utxo}")
    utxo_balance=$(awk '{ print $3 }' <<< "${utxo}")
    total_balance=$((${total_balance}+${utxo_balance}))
    echo TxHash: ${in_addr}#${idx}
    echo ADA: ${utxo_balance}
    tx_in="${tx_in} --tx-in ${in_addr}#${idx}"
done < balance.out
txcnt=$(cat balance.out | wc -l)
echo Total ADA balance: ${total_balance}
echo Number of UTXOs: ${txcnt}
# Draft the tx
cardano-cli transaction build-raw \
    ${tx_in} \
    --tx-out $(cat payment.addr)+0 \
    --tx-out ${destinationAddress}+0 \
    --invalid-hereafter 0 \
    --fee 0 \
    --out-file tx.tmp
# Calculate the fee
fee=$(cardano-cli transaction calculate-min-fee \
    --tx-body-file tx.tmp \
    --tx-in-count ${txcnt} \
    --tx-out-count 2 \
    --witness-count 1 \
    --byron-witness-count 0 \
    --mainnet \
    --protocol-params-file params.json | awk '{ print $1 }')
echo fee: $fee
txOut=$((${total_balance}-${fee}-${amountToSend}))
echo Change Output: ${txOut}
# Build the TX
echo "=========================="
echo "....Building for: ${tx_in}"
echo "=========================="
echo ""
cardano-cli transaction build-raw \
    ${tx_in} \
    --tx-out $(cat payment.addr)+${txOut} \
    --tx-out ${destinationAddress}+${amountToSend} \
    --invalid-hereafter $(( ${currentSlot} + 10000)) \
    --fee ${fee} \
    --out-file tx.raw
mv fullUtxo.out $LOGFOLDER/${TIMESTAMP}_fullUtxo.out
mv balance.out $LOGFOLDER/${TIMESTAMP}_balance.out
mv tx.tmp $LOGFOLDER/${TIMESTAMP}_tx.tmp
cp tx.raw $LOGFOLDER/${TIMESTAMP}_tx.raw
echo ""
echo "===== Finished ====="
echo "Get and Move tx.raw file to Cold for signing"
echo ""

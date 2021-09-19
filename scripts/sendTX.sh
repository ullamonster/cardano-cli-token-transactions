#!/bin/bash
LOGFOLDER=$NODE_HOME/logs/sent
TIMESTAMP=`date "+%Y-%m-%d_%H-%M-%S"`
cardano-cli transaction submit \
    --tx-file tx.signed \
    --mainnet
mv tx.signed $LOGFOLDER/${TIMESTAMP}_tx.signed
echo ""
echo "======= Finished ======"
echo "TX Sent! Check for errors ^"
echo ""

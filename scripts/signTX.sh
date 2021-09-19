#!/bin/bash
cardano-cli transaction sign \
    --tx-body-file tx.raw \
    --signing-key-file payment.skey \
    --mainnet \
    --out-file tx.signed
rm tx.raw
echo ""
echo "===== Finished ====="
echo "move tx.signed back to node for sending!"

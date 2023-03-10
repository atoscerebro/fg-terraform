#!/bin/bash

bash ./scripts/build-root-docs.sh $1
test_docs=$(cat $1)
root_docs=$(cat $2)
if [[ "$test_docs" != "$root_docs" ]]; then
    echo 'Root docs out of sync. Run "make build-docs" to synchronise.'
    rm $1
    exit 1
fi
rm $1
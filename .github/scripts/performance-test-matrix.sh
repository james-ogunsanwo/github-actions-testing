#!/bin/bash

npm i jq

echo "$CURRENT_MATRIX"

filteredMatrix=$(echo "$CURRENT_MATRIX" | jq '.include[] | select(.featureTest == "true")' | jq -n '.include |= [inputs]')
echo "performance_test_matrix=$filteredMatrix" >> $GITHUB_OUTPUT
echo "performance_test_matrix=$filteredMatrix"
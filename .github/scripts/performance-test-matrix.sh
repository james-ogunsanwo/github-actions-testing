#!/bin/bash

echo "$CURRENT_MATRIX"

echo "$CURRENT_MATRIX" > test.json
filteredMatrix=$(jq -r . 'test.json' | jq '.include[] | select(.featureTest == "true")')
test=$(echo "$filteredMatrix" |  jq -n -c '.include |= [inputs]')
echo "performance_test_matrix=$test"
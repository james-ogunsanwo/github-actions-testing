#!/bin/bash

echo $(jq --version)

echo "$CURRENT_MATRIX"

filteredMatrix=$(echo "$CURRENT_MATRIX" | jq '.include[] | select(.featureTest == "true")')
test=$(echo "$filteredMatrix" |  jq -n -c '.include |= [inputs]')
echo "performance_test_matrix=$test"

echo "performance_test_matrix=$test"
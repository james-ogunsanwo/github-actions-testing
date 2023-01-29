#!/bin/bash

echo "$CURRENT_MATRIX" > performance_test.json
filteredMatrix=$(jq -r . 'performance_test.json' | jq '.include[] | select(.featureTest == "true")' |  jq -n -c '.include |= [inputs]')
echo "performance_test_matrix=$filteredMatrix"
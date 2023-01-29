#!/bin/bash

filteredMatrix=$(echo "$CURRENT_MATRIX" | jq '.include[] | select(.featureTest == "true")' | jq -n '.include |= [inputs]' | jq -s -c .[])
echo "performance_test_matrix=$filteredMatrix" >> $GITHUB_OUTPUT
echo "performance_test_matrix=$filteredMatrix"
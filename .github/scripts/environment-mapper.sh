#!/bin/bash

outputMatrix() {
  data=$(jq -n '. |= inputs')
  echo "matrix=$data" >> $GITHUB_OUTPUT
  echo "matrix=$data"
  exit 0
}

eval .github/scripts/convert-configuration.sh dev
eval .github/scripts/convert-configuration.sh test

jq -n '{dev: $dev, test: $test}' \
  --arg dev "$(cat dev-config.json)" \
  --arg test "$(cat test-config.json)" | outputMatrix

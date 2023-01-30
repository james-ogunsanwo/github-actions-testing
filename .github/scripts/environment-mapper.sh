#!/bin/bash

outputMatrix() {
  data=$(jq -n '. |= inputs' | jq -c .)
  echo "matrix=$data" >> "$GITHUB_OUTPUT"
  echo "matrix=$data"
}

eval .github/scripts/convert-configuration.sh dev
eval .github/scripts/convert-configuration.sh test

jq -n '{dev: $dev, test: $test}' \
  --argjson dev "$(cat dev-config.txt)" \
  --argjson test "$(cat test-config.txt)" | outputMatrix

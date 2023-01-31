#!/bin/bash

#outputMatrix() {
#  data=$(jq -n '. |= $1' | jq -c .)
#  echo "$2_matrix=$data" >>"$GITHUB_OUTPUT"
#  echo "$data"
#}
#
#eval .github/scripts/convert-configuration.sh dev
#eval .github/scripts/convert-configuration.sh test
#
##jq -n '{dev: $dev, test: $test}' \
##  --argjson dev "$(cat dev-config.txt)" \
##  --argjson test "$(cat test-config.txt)" | outputMatrix
#
#outputMatrix $(cat dev-config.txt) dev
#outputMatrix $(cat test-config.txt) test


outputMatrix() {
  data=$(jq -n '. |= inputs' | jq -c .)
  echo "$1_matrix=$data" >>"$GITHUB_OUTPUT"
  echo "$data"
}

eval .github/scripts/convert-configuration.sh dev
eval .github/scripts/convert-configuration.sh test

jq -n "$(cat dev-config.json)"  | outputMatrix dev
jq -n "$(cat test-config.json)"  | outputMatrix test
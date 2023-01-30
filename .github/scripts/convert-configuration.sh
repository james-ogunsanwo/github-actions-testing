#!/bin/bash

npm i yq

ENVIRONOMENT=$1

outputEnv () {
  data=$(jq -n '.include |= [inputs]' | jq -s -c .[])
  echo "$data" >> "${ENVIRONOMENT}-config.txt"
  echo "$data"
  exit 0
}

projectNames=()
yq -p yaml -o json ".configuration.projects" deployment-configuration.yaml | jq -c '.[]' | {
  while read projecs; do
    projectList=($(echo "$projecs" | tr -d '"' | tr ";" "\n"))
    if [ "${projectList[1]}" != "$ENVIRONOMENT" ]; then
      projectNames+=("${projectList[0]}")
    fi
  done

  featureTests=()
  yq -p yaml -o json ".configuration.feature-test" deployment-configuration.yaml | jq -c '.[]' | {
    while read featureTestElement; do
      featureTest=$(echo "$featureTestElement" | tr -d '"')
      featureTests+=("$featureTest")
    done

    performanceTests=()
    yq -p yaml -o json ".configuration.performance-test" deployment-configuration.yaml | jq -c '.[]' | {
      while read performanceTestElement; do
        performanceTest=$(echo "$performanceTestElement" | tr -d '"')
        performanceTests+=("$performanceTest")
      done

      NAMESAPCE=$(yq -r ".configuration.namespace" deployment-configuration.yaml)

      index=0
      matrixServices=()
      for projects in "${projectNames[@]}"; do
        featureTest=$([[ " ${featureTests[*]} " =~ ${projects} ]] && echo "true" || echo "false")
        performanceTest=$([[ " ${performanceTests[*]} " =~ ${projects} ]] && echo "true" || echo "false")
        matrixServices+=($(printf '{"serviceName":"%s", "namespace":"%s", "featureTest": "%s", "performanceTest": "%s"}' "${projects}" "${NAMESAPCE}" "${featureTest}" "${performanceTest}"))
        let index=${index}+1
      done

      echo "${matrixServices[@]}" | outputEnv
    }
  }
}
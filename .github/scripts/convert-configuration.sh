#!/bin/bash

VERISON=1.101.1

npm i yq

outputMatrix() {
      data=$(jq -n '.include |= [inputs]' | jq -s -c .[])
      echo "matrix=$data" >>  $GITHUB_OUTPUT
}

projectNames=()
dockerFilePaths=()
dockerFileContext=()
yq -p yaml -o json ".configuration.projects" deployment-configuration.yaml | jq -c '.[]' | {
  while read projecs; do
    projectList=($(echo "$projecs" | tr -d '"' | tr ";" "\n"))
    projectNames+=("${projectList[0]}")

    if [ -e "${projectList[1]}" ]; then
      dockerFilePaths+=("${projectList[1]}")
      dockerFileContext+=("${projectList[2]}")
    else
      echo "invalid docker file path ${projectList[1]}"
      exit 1
    fi
  done

  featureTests=()
  yq -p yaml -o json ".configuration.feature-test" deployment-configuration.yaml | jq -c '.[]' | {
    while read featureTestElement; do
      featureTest=$(echo "$featureTestElement" | tr -d '"')
      featureTests+=("$featureTest")
    done

    NAMESAPCE=$(yq -r ".configuration.namespace" deployment-configuration.yaml)

    index=0
    matrixServices=()
    for projects in "${projectNames[@]}"; do
      featureTest=$([[ " ${featureTests[*]} " =~ ${projects} ]] && echo "true" || echo "false")
      matrixServices+=($(printf '{"serviceName":"%s", "dockerFilePath":"%s", "dockerContext":"%s", "version":"%s","namespace":"%s", "featureTest": "%s"}' "${projects}" "${dockerFilePaths[index]}" "${dockerFileContext[index]}" "${VERISON}" "${NAMESAPCE}" "${featureTest}"))
      let index=${index}+1
    done

    echo "${matrixServices[@]}" | outputMatrix
  }
}

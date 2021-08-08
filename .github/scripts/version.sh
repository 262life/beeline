#!/bin/bash 


CV=$(cat VERSION)
echo Version: "$CV"

if echo "$OSTYPE" | grep -q 'darwin' ; then sedopts='-i .bak'; else sedopts='-i'; fi

sed ${sedopts} -e "s/^\# Version\:.*$/# Version: $CV/g" k8s_shortcuts

echo result:
echo "kubectl-bob-version: $(grep 'Version:' k8s_shortcuts)"


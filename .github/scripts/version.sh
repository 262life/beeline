#!/bin/bash 

CV=$(cat VERSION)
echo Version: "$CV"

if echo "$OSTYPE" | grep -q 'darwin' ; then sedopts='-i .bak'; else sedopts='-i'; fi

sed ${sedopts} -e "s/^\# Version\:.*$/# Version: $CV/g" beeline.sh
sed ${sedopts} -e "s/beeline - Version\:.*$/beeline - Version: $CV/g" beeline.sh

echo result:
echo "kubectl-bob-version: $(grep 'Version:' beeline.sh)"


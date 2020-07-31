#!/bin/bash 


CV=$(cat LATEST_VERSION)
echo Version: $CV

if echo "$OSTYPE" | grep -q 'darwin' ; then sedopts='-i .bak'; else sedopts='-i'; fi


sed ${sedopts} -e "1 s/v.*$/$CV)/g" README.md
sed ${sedopts} -e "s/release\/v.*/$CV)/g" README.md





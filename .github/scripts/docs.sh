#!/bin/bash

# This creates helpdocs

echo "Preparing docs..."
echo ""

echo "# beeline.k8s - Documentation" > DOCUMENTATION.md
echo ""             >> DOCUMENTATION.md

source beeline.sh
kh 2>>DOCUMENTATION.md

echo "Completed docs"
echo ""

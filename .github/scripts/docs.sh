#!/bin/bash

# This creates helpdocs

echo "Preparing docs..."
echo ""

echo "# beeline.k8s - Documentation" > DOCUMENTATION.md
echo ""             >> DOCUMENTATION.md

sudo apt -y install zsh

echo '```' >> DOCUMENTATION.md
zsh ./beeline.sh --help >> DOCUMENTATION.md
echo '```' >> DOCUMENTATION.md

echo "Completed docs"
echo ""

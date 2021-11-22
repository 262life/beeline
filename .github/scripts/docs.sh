#!/bin/bash

# This creates helpdocs

echo "# beeline.k8s - Documentation" > DOCUMENTATION.md
echo ""             >> DOCUMENTATION.md


bash k8s_shortcuts -h 2>>DOCUMENTATION.md

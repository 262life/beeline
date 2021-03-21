#!/bin/bash

# This creates helpdocs

echo "# k8s_shortcuts - Documentation" > DOCUMENTATION.md
echo ""             >> DOCUMENTATION.md


bash k8s_shortcuts -h 2>>DOCUMENTATION.md

#!/bin/bash
# Cleanup Crossplane installation

set -e

echo "This will remove Crossplane and all related resources!"
read -p "Are you sure? (yes/no) " -n 3 -r
echo

if [[ $REPLY =~ ^yes$ ]]; then
    helm uninstall crossplane -n crossplane-system
    kubectl delete namespace crossplane-system
    echo "Cleanup complete!"
else
    echo "Cleanup cancelled."
fi

#!/bin/bash
# Validate all composition files

set -e

echo "Validating compositions..."

find . -name "*composition*.yaml" -type f | while read file; do
    echo "Validating: $file"
    kubectl apply --dry-run=client -f "$file" || echo "Failed: $file"
done

echo "Validation complete!"

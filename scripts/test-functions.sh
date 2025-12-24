#!/bin/bash
# Test composition functions using crossplane render

set -e

if [ $# -lt 3 ]; then
    echo "Usage: $0 <xr.yaml> <composition.yaml> <functions.yaml>"
    exit 1
fi

XR=$1
COMPOSITION=$2
FUNCTIONS=$3

echo "Testing composition function..."
crossplane render "$XR" "$COMPOSITION" "$FUNCTIONS"

echo "Test complete!"

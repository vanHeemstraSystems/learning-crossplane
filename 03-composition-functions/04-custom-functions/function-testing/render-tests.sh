#!/bin/bash
# Test composition functions using crossplane render

echo "Testing composition functions..."
crossplane render xr.yaml composition.yaml functions.yaml

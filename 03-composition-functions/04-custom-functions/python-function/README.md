# Python Composition Function

This directory contains an example Python Composition Function.

## Overview

Python functions are easy to write and great for rapid development.

## Function Structure

The function implements the Function Protocol:
- Receives XR inputs via gRPC
- Processes inputs
- Returns managed resource configurations

## Building

```bash
docker build -t my-python-function:latest .
```

## Testing

```bash
# Test locally
python function.py

# Or use the testing utilities
cd ../function-testing
./render-tests.sh
```

## Deploying

```yaml
apiVersion: pkg.crossplane.io/v1
kind: Function
metadata:
  name: my-python-function
spec:
  package: my-registry/my-python-function:v1.0.0
```

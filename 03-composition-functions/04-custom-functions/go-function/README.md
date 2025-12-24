# Go Composition Function

This directory contains an example Go Composition Function.

## Overview

Go functions provide high performance and type safety.

## Function Structure

The function implements the Function Protocol using gRPC.

## Building

```bash
go build -o function main.go
docker build -t my-go-function:latest .
```

## Testing

```bash
# Test locally
go test ./...

# Or use the testing utilities
cd ../function-testing
./render-tests.sh
```

## Deploying

```yaml
apiVersion: pkg.crossplane.io/v1
kind: Function
metadata:
  name: my-go-function
spec:
  package: my-registry/my-go-function:v1.0.0
```

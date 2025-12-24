# Network Platform

A complete networking platform for provisioning VPCs, subnets, and security groups, enabling self-service network infrastructure.

## Overview

This example demonstrates how to build a networking platform that:

- Provisions VPCs with proper configuration
- Creates subnets in multiple availability zones
- Configures security groups
- Sets up internet gateways and route tables
- Enables network isolation

## Architecture

```
Developer creates Network XR
    ↓
XRD validates input
    ↓
Composition creates:
  - VPC
  - Subnets (public/private)
  - Internet Gateway
  - Route Tables
  - Security Groups
    ↓
Network ready for use
```

## Components

### 1. XRD (Custom API)

Defines the Network API:
- CIDR block
- Region
- Subnet configuration
- Security group rules

See [vpc-xrd.yaml](./vpc-xrd.yaml)

### 2. Compositions

Different compositions for different network components:
- **VPC Composition**: Creates VPC with DNS
- **Subnet Composition**: Creates subnets
- **Security Group Composition**: Creates security groups

See composition files in this directory.

## Installation

### Step 1: Install XRD

```bash
kubectl apply -f vpc-xrd.yaml
```

Verify:

```bash
kubectl get xrd networks.network.example.org
```

### Step 2: Install Compositions

```bash
kubectl apply -f vpc-composition.yaml
kubectl apply -f subnet-composition.yaml
kubectl apply -f security-group-composition.yaml
```

Verify:

```bash
kubectl get composition
```

### Step 3: Create a Network

```yaml
apiVersion: network.example.org/v1alpha1
kind: Network
metadata:
  name: production-network
  namespace: production
spec:
  cidr: 10.0.0.0/16
  region: us-east-1
  environment: production
```

## Usage Examples

### Production Network

```yaml
apiVersion: network.example.org/v1alpha1
kind: Network
metadata:
  name: prod-network
  namespace: production
spec:
  cidr: 10.0.0.0/16
  region: us-east-1
  environment: production
  subnets:
    - name: public-1a
      cidr: 10.0.1.0/24
      az: us-east-1a
      public: true
    - name: private-1a
      cidr: 10.0.2.0/24
      az: us-east-1a
      public: false
```

## Features

### Multi-AZ Support

Automatically creates subnets in multiple availability zones for high availability.

### Public/Private Subnets

Supports both public and private subnets:
- **Public**: Internet-facing resources
- **Private**: Internal-only resources

### Security Groups

Automatic security group creation with configurable rules.

### Internet Gateway

Automatic internet gateway setup for public subnets.

## Customization

### Adding Custom Subnets

Extend the composition to create additional subnets:

```yaml
resources:
  - name: custom-subnet
    base:
      apiVersion: ec2.aws.crossplane.io/v1beta1
      kind: Subnet
```

### Custom Security Rules

Add security group rules based on XR configuration:

```yaml
patches:
  - type: FromCompositeFieldPath
    fromFieldPath: spec.securityRules
    toFieldPath: spec.forProvider.ingress
```

## Best Practices Demonstrated

1. **Network Isolation**: Proper CIDR planning
2. **Multi-AZ**: High availability design
3. **Security**: Security groups and network policies
4. **Documentation**: Complete network documentation

## Troubleshooting

### Network Not Creating

```bash
# Check Network status
kubectl describe network my-network

# Check VPC creation
kubectl get vpc
```

### Subnets Not Appearing

```bash
# Check subnet resources
kubectl get subnet

# Check composition
kubectl describe composition subnet-composition
```

## Next Steps

1. **Customize**: Adapt to your network needs
2. **Add Features**: Add VPN, Direct Connect, etc.
3. **Multi-Cloud**: Support multiple cloud providers
4. **Production**: Deploy in your production environment

---

**Ready for the next example?** Check out [Observability Platform](../04-observability-platform/)!

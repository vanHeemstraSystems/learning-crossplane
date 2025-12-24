#!/usr/bin/env python3
"""
Example Python Composition Function
Implements the Crossplane Function Protocol
"""

import json
import sys
from typing import Dict, Any

def process_xr(xr: Dict[str, Any]) -> Dict[str, Any]:
    """
    Process Composite Resource and generate managed resources.
    
    Args:
        xr: Composite Resource specification
        
    Returns:
        Dictionary with managed resources
    """
    # Extract XR spec
    spec = xr.get('spec', {})
    metadata = xr.get('metadata', {})
    
    # Generate managed resources based on XR
    resources = []
    
    # Example: Create VPC if cidr is provided
    if 'cidr' in spec:
        vpc = {
            'apiVersion': 'ec2.aws.crossplane.io/v1beta1',
            'kind': 'VPC',
            'metadata': {
                'name': f"{metadata.get('name', 'network')}-vpc"
            },
            'spec': {
                'forProvider': {
                    'cidrBlock': spec['cidr'],
                    'enableDnsHostnames': True,
                    'enableDnsSupport': True
                },
                'providerConfigRef': {
                    'name': 'default'
                }
            }
        }
        resources.append(vpc)
    
    return {
        'desired': {
            'resources': resources
        }
    }

def main():
    """Main function entry point."""
    # Read input from stdin (Function Protocol)
    input_data = json.load(sys.stdin)
    
    # Extract XR from input
    xr = input_data.get('observed', {}).get('composite', {})
    
    # Process XR
    result = process_xr(xr)
    
    # Write output to stdout
    print(json.dumps(result, indent=2))

if __name__ == '__main__':
    main()

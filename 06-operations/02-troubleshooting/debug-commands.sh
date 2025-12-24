#!/bin/bash
# Crossplane Debug Commands
# Collection of useful commands for debugging Crossplane issues

set -e

NAMESPACE="${NAMESPACE:-crossplane-system}"
RESOURCE_NAME="${1:-}"
RESOURCE_NAMESPACE="${2:-default}"

echo "=== Crossplane Debug Commands ==="
echo ""

# ============================================
# System Status
# ============================================

echo "--- System Status ---"
kubectl get pods -n $NAMESPACE
echo ""

# ============================================
# Crossplane Core
# ============================================

echo "--- Crossplane Core Status ---"
kubectl get deployment -n $NAMESPACE -l app=crossplane
kubectl get pods -n $NAMESPACE -l app=crossplane
echo ""

echo "--- Crossplane Logs (last 50 lines) ---"
kubectl logs -n $NAMESPACE -l app=crossplane --tail=50
echo ""

# ============================================
# Providers
# ============================================

echo "--- Provider Status ---"
kubectl get providers
kubectl get providerrevisions
echo ""

echo "--- Provider Pods ---"
kubectl get pods -n $NAMESPACE -l component=provider
echo ""

if [ ! -z "$RESOURCE_NAME" ]; then
    echo "--- Provider Logs for Resource ---"
    PROVIDER=$(kubectl get xr $RESOURCE_NAME -n $RESOURCE_NAMESPACE -o jsonpath='{.spec.resourceRefs[0].apiVersion}' | cut -d'/' -f1)
    kubectl logs -n $NAMESPACE -l provider=$PROVIDER --tail=100
    echo ""
fi

# ============================================
# Composite Resources
# ============================================

echo "--- Composite Resource Definitions ---"
kubectl get xrd
echo ""

echo "--- Composite Resources (all namespaces) ---"
kubectl get xr -A
echo ""

if [ ! -z "$RESOURCE_NAME" ]; then
    echo "--- Composite Resource Details ---"
    kubectl get xr $RESOURCE_NAME -n $RESOURCE_NAMESPACE -o yaml
    echo ""
    
    echo "--- Composite Resource Status ---"
    kubectl describe xr $RESOURCE_NAME -n $RESOURCE_NAMESPACE
    echo ""
fi

# ============================================
# Compositions
# ============================================

echo "--- Compositions ---"
kubectl get composition
echo ""

# ============================================
# Managed Resources
# ============================================

echo "--- Managed Resources (all namespaces) ---"
kubectl get managed -A
echo ""

if [ ! -z "$RESOURCE_NAME" ]; then
    echo "--- Managed Resources for XR ---"
    kubectl get managed -n $RESOURCE_NAMESPACE --selector=crossplane.io/composite=$RESOURCE_NAME
    echo ""
fi

# ============================================
# Events
# ============================================

echo "--- Recent Events ---"
kubectl get events -n $RESOURCE_NAMESPACE --sort-by='.lastTimestamp' | tail -20
echo ""

if [ ! -z "$RESOURCE_NAME" ]; then
    echo "--- Events for Resource ---"
    kubectl get events -n $RESOURCE_NAMESPACE --field-selector involvedObject.name=$RESOURCE_NAME --sort-by='.lastTimestamp'
    echo ""
fi

# ============================================
# Provider Configs
# ============================================

echo "--- Provider Configs ---"
kubectl get providerconfig -A
echo ""

# ============================================
# Secrets
# ============================================

echo "--- Secrets in Crossplane Namespace ---"
kubectl get secrets -n $NAMESPACE
echo ""

# ============================================
# Functions
# ============================================

echo "--- Composition Functions ---"
kubectl get functions
echo ""

# ============================================
# Resource Conditions
# ============================================

if [ ! -z "$RESOURCE_NAME" ]; then
    echo "--- Resource Conditions ---"
    kubectl get xr $RESOURCE_NAME -n $RESOURCE_NAMESPACE -o jsonpath='{.status.conditions}' | jq '.'
    echo ""
fi

# ============================================
# Resource References
# ============================================

if [ ! -z "$RESOURCE_NAME" ]; then
    echo "--- Resource References ---"
    kubectl get xr $RESOURCE_NAME -n $RESOURCE_NAMESPACE -o jsonpath='{.status.resourceRefs}' | jq '.'
    echo ""
fi

echo "=== Debug Complete ==="

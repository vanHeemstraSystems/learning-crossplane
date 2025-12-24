package main

import (
	"context"
	"encoding/json"
	"fmt"
	"os"

	"github.com/crossplane/function-sdk-go/resource"
	"github.com/crossplane/function-sdk-go/response"
	"github.com/crossplane/function-sdk-go/request"
	fnv1beta1 "github.com/crossplane/function-sdk-go/proto/v1beta1"
	"google.golang.org/grpc"
)

// Example Go Composition Function
// Implements the Crossplane Function Protocol

func processXR(req *fnv1beta1.RunFunctionRequest) (*fnv1beta1.RunFunctionResponse, error) {
	// Extract XR from request
	xr, err := request.GetObservedCompositeResource(req)
	if err != nil {
		return nil, fmt.Errorf("failed to get XR: %w", err)
	}

	// Extract spec
	spec := xr.Resource.Object["spec"].(map[string]interface{})
	metadata := xr.Resource.Object["metadata"].(map[string]interface{})

	// Generate managed resources
	resources := []resource.Desired{}

	// Example: Create VPC if cidr is provided
	if cidr, ok := spec["cidr"].(string); ok {
		vpc := resource.NewDesired()
		vpc.SetAPIVersion("ec2.aws.crossplane.io/v1beta1")
		vpc.SetKind("VPC")
		vpc.SetName(fmt.Sprintf("%s-vpc", metadata["name"]))

		// Set spec
		vpc.Object["spec"] = map[string]interface{}{
			"forProvider": map[string]interface{}{
				"cidrBlock":          cidr,
				"enableDnsHostnames": true,
				"enableDnsSupport":   true,
			},
			"providerConfigRef": map[string]interface{}{
				"name": "default",
			},
		}

		resources = append(resources, vpc)
	}

	// Create response
	rsp := response.To(req, response.WithDesired(resources...))
	return rsp, nil
}

func main() {
	// This is a simplified example
	// Full implementation requires gRPC server setup
	fmt.Println("Go Composition Function")
	fmt.Println("See Crossplane function-sdk-go for complete implementation")
	os.Exit(0)
}

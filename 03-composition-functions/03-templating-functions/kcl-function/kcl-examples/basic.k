# Basic KCL Example
# KCL provides type-safe templating for Kubernetes resources

# Example: VPC resource generation
vpc = {
    apiVersion = "ec2.aws.crossplane.io/v1beta1"
    kind = "VPC"
    metadata = {
        name = "{}.vpc".format(option("name"))
    }
    spec = {
        forProvider = {
            cidrBlock = option("cidr")
            enableDnsHostnames = True
            enableDnsSupport = True
        }
        providerConfigRef = {
            name = "default"
        }
    }
}

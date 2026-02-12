# Computed values reused across the configuration

locals {
  # Common name prefix for all resources
  name_prefix = "${var.project_name}-${var.environment}"

  # Merge common tags with environment-specific tags
  common_tags = merge(
    var.common_tags,
    {
      Project     = var.project_name
      Environment = var.environment
      Terraform   = "true"
    }
  )

  # Network configuration
  azs = slice(data.aws_availability_zones.available.names, 0, var.availability_zones_count)

  # Kubernetes cluster tags (required for EKS)
  # This tag tells AWS which subnets the EKS cluster can use
  kubernetes_cluster_name = "${local.name_prefix}-eks"

  kubernetes_tags = {
    "kubernetes.io/cluster/${local.name_prefix}-eks" = "shared"
  }
}

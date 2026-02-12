# VPC Outputs

output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "vpc_cidr" {
  description = "CIDR block of the VPC"
  value       = aws_vpc.main.cidr_block
}

# Subnet Outputs

output "public_subnet_ids" {
  description = "List of public subnet IDs (for load balancers, NAT instances)"
  value       = [aws_subnet.public.id, aws_subnet.public_2.id]
}

output "private_subnet_ids" {
  description = "List of private subnet IDs (for EKS nodes, databases)"
  value       = [aws_subnet.private.id, aws_subnet.private_2.id]
}

output "public_subnet_cidrs" {
  description = "CIDR blocks of public subnets"
  value       = [aws_subnet.public.cidr_block, aws_subnet.public_2.cidr_block]
}

output "private_subnet_cidrs" {
  description = "CIDR blocks of private subnets"
  value       = [aws_subnet.private.cidr_block, aws_subnet.private_2.cidr_block]
}

output "availability_zones" {
  description = "Availability zones used for subnets"
  value       = [aws_subnet.public.availability_zone, aws_subnet.public_2.availability_zone]
}

# NAT Gateway Outputs

output "nat_gateway_id" {
  description = "ID of the NAT Gateway"
  value       = aws_nat_gateway.main.id
}

output "nat_gateway_public_ip" {
  description = "Public IP of the NAT Gateway"
  value       = aws_eip.nat.public_ip
}

# Route Table Outputs

output "public_route_table_id" {
  description = "ID of the public route table"
  value       = aws_route_table.public_rt.id
}

output "private_route_table_id" {
  description = "ID of the private route table"
  value       = aws_route_table.private_rt.id
}

# Gateway Outputs

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.igw.id
}

# Security Group Outputs

output "eks_cluster_security_group_id" {
  description = "Security group ID for EKS cluster"
  value       = aws_security_group.eks_cluster_sg.id
}

# Network summary — useful for debugging and documentation

output "network_summary" {
  description = "Summary of network configuration"
  value = {
    vpc_id             = aws_vpc.main.id
    vpc_cidr           = aws_vpc.main.cidr_block
    availability_zones = [aws_subnet.public.availability_zone, aws_subnet.public_2.availability_zone]
    public_subnets     = [aws_subnet.public.id, aws_subnet.public_2.id]
    private_subnets    = [aws_subnet.private.id, aws_subnet.private_2.id]
    nat_gateway_ip     = aws_eip.nat.public_ip
  }
}

# EKS Cluster Outputs

output "eks_cluster_id" {
  description = "ID of the EKS cluster"
  value       = aws_eks_cluster.main.id
}

output "eks_cluster_name" {
  description = "Name of the EKS cluster"
  value       = aws_eks_cluster.main.name
}

output "eks_cluster_endpoint" {
  description = "Endpoint for EKS cluster API server"
  value       = aws_eks_cluster.main.endpoint
}

output "eks_cluster_certificate_authority" {
  description = "Certificate authority data for EKS cluster"
  value       = aws_eks_cluster.main.certificate_authority[0].data
  sensitive   = true
}

output "eks_cluster_version" {
  description = "Kubernetes version of the EKS cluster"
  value       = aws_eks_cluster.main.version
}

output "eks_oidc_provider_arn" {
  description = "ARN of the OIDC provider for IRSA"
  value       = aws_iam_openid_connect_provider.eks.arn
}

output "eks_node_group_id" {
  description = "ID of the EKS node group"
  value       = aws_eks_node_group.main.id
}

output "eks_node_group_status" {
  description = "Status of the EKS node group"
  value       = aws_eks_node_group.main.status
}

# Quick Start

output "kubectl_config_command" {
  description = "Command to configure kubectl"
  value       = "aws eks update-kubeconfig --region ${var.region} --name ${aws_eks_cluster.main.name}"
}
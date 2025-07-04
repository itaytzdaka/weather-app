variable "region" {
  description = "AWS Region to deploy resources"
  type = string
}

variable "cluster_name" {
  description = "EKS Kubernetes name"
  type       = string
}

variable "vpc_id" {
  description = "vpc id"
  type        = string
}

variable "subnet_ids" {
  description = "vpc subnets ids"
  type = list(string)
}

variable "eks_version" {
  description = "EKS Kubernetes version"
  type        = string
}

variable "eks_cluster_role_name" {
  description = "The name of the EKS cluster IAM role"
  type        = string
}

variable "admin_ip" {
  description = "The IP address allowed to access the EKS API via kubectl"
  type        = string
}

variable "eks_cluster_policy_arns" {
  description = "List of IAM policy ARNs to attach to the EKS cluster role"
  type        = list(string)
}

variable "storage_class_name" {
  description = "Name of the Kubernetes storage class"
  type        = string
}

variable "reclaim_policy" {
  description = "Policy for reclaiming volumes"
  type        = string
}

variable "volume_binding_mode" {
  description = "Volume binding mode"
  type        = string
}

variable "allow_volume_expansion" {
  description = "Whether to allow volume expansion"
  type        = bool
}

variable "eks_nodes_desired_size" {
  type        = number
  description = "Desired number of nodes"
}

variable "eks_nodes_min_size" {
  type        = number
  description = "Minimum number of nodes"
}

variable "eks_nodes_max_size" {
  type        = number
  description = "Maximum number of nodes"
}

variable "eks_launch_template_version" {
  type        = string
  description = "Launch template version to use"
}

variable "eks_node_role_name" {
  description = "Name of the IAM role for EKS nodes"
  type        = string
}

variable "eks_node_policy_arns" {
  description = "List of IAM policy ARNs to attach to the EKS worker node role"
  type        = list(string)
}

variable "eks_node_instance_type" {
  description = "Instance type for EKS nodes"
  type        = string
}

variable "eks_node_volume_size" {
  description = "Root volume size in GiB"
  type        = number
}

variable "eks_node_volume_type" {
  description = "Root volume type"
  type        = string
}

variable "eks_node_ami_owner" {
  description = "Owner ID of the EKS AMI (Amazon EKS official account)"
  type        = string
}

variable "eks_node_ami_name_filter" {
  description = "Filter pattern for the EKS AMI name"
  type        = string
}

variable "eks_node_ami_architecture" {
  description = "Architecture for the EKS AMI"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
}


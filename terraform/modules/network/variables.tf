variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "subnets" {
  description = "CIDR block and Availability Zones for Public Subnets"

  type = map(object({
    cidr_block = string
    availability_zone = string
  }))
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
}

variable "cluster_name" {
  description = "EKS Kubernetes name"
  type        = string
}

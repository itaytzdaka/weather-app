output "vpc_id" {
  value = aws_vpc.TODO-vpc.id
}

output "subnet_ids" {
  description = "Subnet IDs created"
  value = {
    for k, subnet in aws_subnet.subnets : k => subnet.id
  }
}

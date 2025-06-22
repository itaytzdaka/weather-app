resource "aws_vpc" "TODO-vpc" {
  cidr_block = var.vpc_cidr

  tags = merge(var.tags, {
    Name = "TODO-vpc"
  })
}

resource "aws_subnet" "subnets" {
  
  for_each = var.subnets 

  vpc_id            = aws_vpc.TODO-vpc.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone
  map_public_ip_on_launch = true

  tags = merge(
    var.tags,
    {
      Name = each.key
      "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    }
  )
}


resource "aws_internet_gateway" "TODO-igw" {
  vpc_id = aws_vpc.TODO-vpc.id

  tags = merge(var.tags, {
    Name = "TODO-igw"
  })
}

resource "aws_route_table" "TODO-pub-rtb" {
  vpc_id = aws_vpc.TODO-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.TODO-igw.id
  }

  tags = merge(var.tags, {
    Name = "TODO-pub-rtb"
  })
}

resource "aws_route_table_association" "route_table_associations" {
  for_each = aws_subnet.subnets

  subnet_id = each.value.id
  route_table_id = aws_route_table.TODO-pub-rtb.id
}

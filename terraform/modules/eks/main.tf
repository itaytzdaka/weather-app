resource "aws_eks_cluster" "cluster" {

  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn
  version  = var.eks_version

  vpc_config {
    subnet_ids = var.subnet_ids
    security_group_ids = [aws_security_group.eks_sg.id]
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policies
  ]

  tags = merge(var.tags, {
    Name = var.cluster_name
  })
}


resource "aws_iam_role" "eks_cluster_role" {

  name = var.eks_cluster_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "eks.amazonaws.com" },
      Action = "sts:AssumeRole"
    }]
  })

  tags = merge(var.tags, {
    Name = var.eks_cluster_role_name
  })
}


resource "aws_iam_role_policy_attachment" "eks_cluster_policies" {

  for_each   = toset(var.eks_cluster_policy_arns)

  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = each.value
}


resource "aws_security_group" "eks_sg" {

  name        = "${var.cluster_name}-eks-control-plane"
  description = "Allow secure access to EKS API"
  vpc_id      = var.vpc_id

  # Allow access to Kubernetes API server (port 443) from your IP
  ingress {
    description     = "Allow nodes to communicate with control plane"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.eks_nodes_sg.id]
  }

  # Allow Admin to use kubectl
  ingress {
    description = "Allow kubectl access to EKS API from admin IP"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.admin_ip]
  }

  # Allow all outbound traffic (required for control plane)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.cluster_name}-eks-control-plane"
  })
}


resource "aws_eks_addon" "ebs_csi" {

  cluster_name = aws_eks_cluster.cluster.name
  addon_name   = "aws-ebs-csi-driver"
  
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

  depends_on = [aws_eks_node_group.eks_node_group]

  tags = merge(var.tags, {
    Name = "${var.cluster_name}-ebs_csi"
  })
}


resource "kubernetes_storage_class" "gp3" {

  metadata {
    name = var.storage_class_name
    annotations = {
      "storageclass.kubernetes.io/is-default-class" = "true"
    }
  }

  storage_provisioner = "ebs.csi.aws.com"

  parameters = {
    type = "gp3"
  }

  reclaim_policy        = var.reclaim_policy
  volume_binding_mode   = var.volume_binding_mode
  allow_volume_expansion = var.allow_volume_expansion
}


resource "kubernetes_cluster_role" "ingress_nginx_admission" {

  metadata {
    name = "ingress-nginx-admission"
  }

  rule {
    api_groups = ["admissionregistration.k8s.io"]
    resources  = ["validatingwebhookconfigurations"]
    verbs      = ["get", "patch"]
  }
}


resource "kubernetes_cluster_role_binding" "ingress_nginx_admission" {
  
  metadata {
    name = "ingress-nginx-admission"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.ingress_nginx_admission.metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    name      = "ingress-nginx-admission"
    namespace = "ingress-nginx"
  }
}


# --------------------------------------------------------------------------



resource "aws_eks_node_group" "eks_node_group" {

  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = "${var.cluster_name}-node-group"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = var.eks_nodes_desired_size
    min_size     = var.eks_nodes_min_size
    max_size     = var.eks_nodes_max_size
  }

  depends_on = [aws_iam_role_policy_attachment.worker_node_policies]

  launch_template {
    id      = aws_launch_template.eks_nodes.id
    version = var.eks_launch_template_version
  }

  tags = merge(var.tags, {
    Name = "${var.cluster_name}-node"
  })
}


resource "aws_iam_role" "eks_node_role" {

  name = var.eks_node_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "ec2.amazonaws.com" },
      Action = "sts:AssumeRole"
    }]
  })

  tags = merge(var.tags, {
    Name = var.eks_node_role_name
  })
}


resource "aws_iam_role_policy_attachment" "worker_node_policies" {

  for_each = toset(var.eks_node_policy_arns)

  role       = aws_iam_role.eks_node_role.name
  policy_arn = each.value
}


resource "aws_launch_template" "eks_nodes" {

  name_prefix   = "eks-nodes-"
  image_id      = data.aws_ami.eks.id
  instance_type = var.eks_node_instance_type

  vpc_security_group_ids = [aws_security_group.eks_nodes_sg.id]


  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = var.eks_node_volume_size
      volume_type = var.eks_node_volume_type
    }
  }

  user_data = base64encode(<<-EOF
    #!/bin/bash
    set -o xtrace
    /etc/eks/bootstrap.sh ${var.cluster_name}
    EOF
  )

  tag_specifications {
    resource_type = "instance"
    tags = merge(var.tags, {
        Name = "${var.cluster_name}-node"
    })
  }
}


data "aws_ami" "eks" {
  most_recent = true
  owners      = [var.eks_node_ami_owner]

  filter {
    name   = "name"
    values = [var.eks_node_ami_name_filter] # Adjust to your Kubernetes version
  }

  filter {
    name   = "architecture"
    values = [var.eks_node_ami_architecture]
  }
}


resource "aws_security_group" "eks_nodes_sg" {

  name        = "${var.cluster_name}-nodes-sg"
  description = "Security group for EKS nodes"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow all traffic from within the same SG"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  ingress {
    description = "Allow webhook traffic from control plane"
    from_port   = 8443
    to_port     = 8443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description     = "Allow kubelet traffic from control plane"
    from_port       = 10250
    to_port         = 10250
    protocol        = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.cluster_name}-nodes-sg"
  })
}


resource "null_resource" "apply_aws_auth" {
  depends_on = [aws_eks_cluster.cluster]

  provisioner "local-exec" {
    command = <<EOT
      aws eks update-kubeconfig --region ${var.region} --name ${aws_eks_cluster.cluster.name}
    EOT
  }
}


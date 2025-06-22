terraform {
  required_version = ">= 1.10"
  
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.14.0"
    }
  }

  backend "s3" {
    bucket       = "terraform"
    key          = "terraform.tfstate"
    region       = "ap-south-1"
    use_lockfile = true
  }
}


module "network" {
  source       = "./modules/network"
  cluster_name = var.cluster_name
  vpc_cidr     = var.vpc_cidr
  subnets      = var.subnets
  tags         = var.tags
}


module "eks" {
  source                      = "./modules/eks"

  cluster_name                = var.cluster_name
  subnet_ids                  = values(module.network.subnet_ids)
  vpc_id                      = module.network.vpc_id
  eks_version                 = var.eks_version
  eks_cluster_role_name       = var.eks_cluster_role_name
  admin_ip                    = var.admin_ip
  eks_cluster_policy_arns     = var.eks_cluster_policy_arns

  storage_class_name          = var.storage_class_name
  reclaim_policy              = var.reclaim_policy
  volume_binding_mode         = var.volume_binding_mode
  allow_volume_expansion      = var.allow_volume_expansion

  eks_nodes_desired_size      = var.eks_nodes_desired_size
  eks_nodes_min_size          = var.eks_nodes_min_size
  eks_nodes_max_size          = var.eks_nodes_max_size
  eks_launch_template_version = var.eks_launch_template_version

  eks_node_role_name          = var.eks_node_role_name
  eks_node_policy_arns        = var.eks_node_policy_arns
  eks_node_instance_type      = var.eks_node_instance_type
  eks_node_volume_size        = var.eks_node_volume_size
  eks_node_volume_type        = var.eks_node_volume_type
  eks_node_ami_owner          = var.eks_node_ami_owner
  eks_node_ami_name_filter    = var.eks_node_ami_name_filter
  eks_node_ami_architecture   = var.eks_node_ami_architecture

  tags                        = var.tags
}


module "argocd" {
  source        = "./modules/argocd"

  providers = {
    kubectl = kubectl.gavin
  }

  namespace                = var.argocd_namespace
  chart_version            = var.argocd_chart_version
  argocd_git_repo_url      = var.argocd_git_repo_url
  argocd_application_name  = var.argocd_application_name
  argocd_git_repo_path     = var.argocd_git_repo_path
  argocd_repo_secret_name  = var.argocd_repo_secret_name

  ssh_private_key          = local.ssh_private_key

}

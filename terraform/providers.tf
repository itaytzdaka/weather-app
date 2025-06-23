provider "aws" {
  region = var.region
}

data "aws_eks_cluster_auth" "auth" {
  name = var.cluster_name
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_ca)
  token                  = data.aws_eks_cluster_auth.auth.token
}

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_ca)
    token                  = data.aws_eks_cluster_auth.auth.token
  }
}

# provider "helm" {
#   kubernetes_host                   = module.eks.cluster_endpoint
#   kubernetes_cluster_ca_certificate = base64decode(module.eks.cluster_ca)
#   kubernetes_token                  = data.aws_eks_cluster_auth.auth.token
#   kubernetes_load_config_file       = false
# }

provider "kubectl" {
  alias                  = "gavin"
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_ca)
  token                  = data.aws_eks_cluster_auth.auth.token
  load_config_file       = false
}
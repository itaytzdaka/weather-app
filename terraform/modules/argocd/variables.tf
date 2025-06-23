variable "namespace" {
  description = "Namespace to deploy Argo CD"
  type        = string
}

variable "chart_version" {
  description = "Helm chart version for Argo CD"
  type        = string
}

# variable "argocd_application_name" {
#   description = "The name of the ArgoCD root application"
#   type        = string
# }

# variable "argocd_git_repo_url" {
#   description = "Git SSH URL for ArgoCD to sync applications"
#   type        = string
# }

# variable "argocd_git_repo_path" {
#   description = "Path in the Git repo to ArgoCD application definitions"
#   type        = string
# }

# variable "argocd_repo_secret_name" {
#   description = "Kubernetes secret name for the ArgoCD Git repo credentials"
#   type        = string
# }

# variable "ssh_private_key" {
#   description = "Private SSH key for accessing Git repository"
#   type        = string
#   sensitive   = true
# }
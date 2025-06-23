# data "aws_secretsmanager_secret" "argocd_gitlab_ssh_key" {
#   name = "itay/argocd/ssh-key"
# }

# data "aws_secretsmanager_secret_version" "argocd_gitlab_ssh_key" {
#   secret_id = data.aws_secretsmanager_secret.argocd_gitlab_ssh_key.id
# }

# locals {
#   ssh_private_key = jsondecode(data.aws_secretsmanager_secret_version.argocd_gitlab_ssh_key.secret_string)["sshPrivateKey"]
# }
terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.14.0"
    }
  }
}

resource "helm_release" "argocd" {
    
  name       = "argocd"
  namespace  = var.namespace
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = var.chart_version

  create_namespace = true

  # values = [
  #   yamlencode({
  #     extraObjects = [
  #       {
  #         apiVersion = "argoproj.io/v1alpha1"
  #         kind       = "Application"
  #         metadata = {
  #           name      = var.argocd_application_name
  #           namespace = var.namespace
  #         }
  #         spec = {
  #           project = "default"
  #           source = {
  #             repoURL        = var.argocd_git_repo_url
  #             targetRevision = "main"
  #             path           = var.argocd_git_repo_path
  #             directory = {
  #               recurse = true
  #             }
  #           }
  #           destination = {
  #             server    = "https://kubernetes.default.svc"
  #             namespace = var.namespace
  #           }
  #           syncPolicy = {
  #             automated = {
  #               prune    = true
  #               selfHeal = true
  #             }
  #           }
  #         }
  #       }
  #     ]
  #   })
  # ]

  # values = [
  #   yamlencode({
  #     crds = {
  #       install = true
  #     }

  #     # configs = {
  #     #   repositories = {
  #     #     gitops-repo = {
  #     #       url  = var.argocd_git_repo_url
  #     #       type = "git"
  #     #       name = "gitops-repo"
  #     #       sshPrivateKeySecret = var.argocd_repo_secret_name
  #     #     }
  #     #   }
  #     # }

  #     applications = [
  #       {
  #         name      = var.argocd_application_name
  #         namespace = var.namespace
  #         project   = "default"
  #         source = {
  #           repoURL        = var.argocd_git_repo_url
  #           targetRevision = "main"
  #           path           = var.argocd_git_repo_path
  #           directory = {
  #             recurse = true
  #           }
  #         }
  #         destination = {
  #           server    = "https://kubernetes.default.svc"
  #           namespace = var.namespace
  #         }
  #         syncPolicy = {
  #           automated = {
  #             prune    = true
  #             selfHeal = true
  #           }
  #         }
  #       }
  #     ]
  #   })
  # ]

}




# resource "kubernetes_manifest" "argocd_app_of_apps" {
#   depends_on = [helm_release.argocd]

#   manifest = {
#     apiVersion = "argoproj.io/v1alpha1"
#     kind       = "Application"
#     metadata = {
#       name      = var.argocd_application_name
#       namespace = var.namespace
#     }
#     spec = {
#       project = "default"
#       source = {
#         repoURL        = var.argocd_git_repo_url
#         targetRevision = "main"
#         path           = var.argocd_git_repo_path
#         directory = {
#           recurse = true
#         }
#       }
#       destination = {
#         server    = "https://kubernetes.default.svc"
#         namespace = var.namespace
#       }
#       syncPolicy = {
#         automated = {
#           prune    = true
#           selfHeal = true
#         }
#       }
#     }
#   }
# }

resource "kubectl_manifest" "argocd_application" {
  yaml_body = file("${path.module}/app-of-apps.yaml")
  depends_on = [helm_release.argocd]
}


resource "kubernetes_secret" "argocd_git_repo" {
  metadata {
    name      = var.argocd_repo_secret_name
    namespace = var.namespace

    annotations = {
      "managed-by" = "argocd.argoproj.io"
    }

    labels = {
      "argocd.argoproj.io/secret-type" = "repository"
    }
  }
  

  data = {
    type          = "git"
    url           = var.argocd_git_repo_url
    project       = "default"
    # sshPrivateKey = var.ssh_private_key
  }

  type = "Opaque"

  depends_on = [helm_release.argocd]


}
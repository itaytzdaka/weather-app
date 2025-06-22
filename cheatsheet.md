# Cluster Access

aws eks update-kubeconfig --region ap-south-1 --name itay-cluster


# ArgoCD Access

kubectl port-forward svc/argocd-server -n argocd 8080:443

https://localhost:8080

user: admin
password: run command:

kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 --decode


# application URL: 

https://itay-protfolio.ddns.net/

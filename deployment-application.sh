#!/bin/bash

# set context to application-cluster
KUBE_CONTEXT="kind-application-cluster"
kubectl config use-context "$KUBE_CONTEXT"

# install OLM
curl -sL https://github.com/operator-framework/operator-lifecycle-manager/releases/download/v0.26.0/install.sh | bash -s v0.26.0

# create argocd namespace if not present
ARGOCD_NAMESPACE="argocd"
kubectl get ns "$ARGOCD_NAMESPACE" || kubectl create ns "$ARGOCD_NAMESPACE"

# deploy argocd operator from operatorhub manifests
echo "deploy argocd operator..."
kubectl create -f https://operatorhub.io/install/argocd-operator.yaml -n "operators"

echo "waiting for argocd operator to become ready..."
#kubectl rollout status deployment/argocd-operator -n "$ARGOCD_NAMESPACE"
echo "argocd operator is ready"

# deploy application cluster argocd custom resources
kubectl apply -f configs/application/argocd-cluster.yaml -n "$ARGOCD_NAMESPACE" # argocd cluster
kubectl apply -f configs/application/calico-operator-application.yaml -n "$ARGOCD_NAMESPACE" # argocd application
kubectl apply -f configs/application/cert-manager-application.yaml -n "$ARGOCD_NAMESPACE" # argocd application
kubectl apply -f configs/application/mongodb-operator-application.yaml -n "$ARGOCD_NAMESPACE" # argocd application
kubectl apply -f configs/application/nginx-ingress-controller-application.yaml -n "$ARGOCD_NAMESPACE" # argocd application
kubectl apply -f configs/application/postgresql-operator-application.yaml -n "$ARGOCD_NAMESPACE" # argocd application
kubectl apply -f configs/application/rabbitmq-cluster-operator-application.yaml -n "$ARGOCD_NAMESPACE" # argocd application
kubectl apply -f configs/application/rabbitmq-messaging-topology-operator-application.yaml -n "$ARGOCD_NAMESPACE" # argocd application
kubectl apply -f configs/application/redis-operator-application.yaml -n "$ARGOCD_NAMESPACE" # argocd application
kubectl apply -f configs/application/rook-ceph-csi-operator-application.yaml -n "$ARGOCD_NAMESPACE" # argocd application

# ingress
kubectl apply -f configs/application/argocd-ingress.yaml -n "$ARGOCD_NAMESPACE" # argocd ingress

echo "ArgoCD and Applications deployed successfully in namespace '$ARGOCD_NAMESPACE' of context '$KUBE_CONTEXT'."

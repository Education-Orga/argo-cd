#!/bin/bash

# set context to edge-cluster
KUBE_CONTEXT="kind-edge-cluster"
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

# deploy edge cluster argocd custom resources
kubectl apply -f configs/edge/argocd-cluster.yaml -n "$ARGOCD_NAMESPACE" # argocd cluster
kubectl apply -f configs/edge/traefik-operator-application.yaml -n "$ARGOCD_NAMESPACE" # argocd application

echo "ArgoCD and Traefik deployed successfully in namespace '$ARGOCD_NAMESPACE' of context '$KUBE_CONTEXT'."

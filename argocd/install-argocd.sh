#!/usr/bin/env bash
# install-argocd.sh - Installs Argo CD on your Minikibe cluster
set -e

echo "==> Creating argocd namespace..."
kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -

echo "==> Installing Argo CD (stable release)..."
kubectl apply -n argocd -f \
    https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

echo "==> Wating for Argo CD server to be ready (this takes ~2 min)..."
kubectl rollout status deployment/argocd-server -n argocd --timeout=180s

echo ""
echo "Argo CD is ready!"
echo ""
echo "==> Admin password:"
kubectl get secret argocd-initial-admin-secret \
    -n argocd \
    -o jsonpath="{.data.password}" | base64 -d
echo ""
echo ""
echo "==> Run this in a seperate terminal to access the UI"
echo "      kubectl port-forward svc/argocd-server -n argocd 8080:443"
echo ""
echo "==>   Then open: https://localhost:8080"
echo "      Username: admin"
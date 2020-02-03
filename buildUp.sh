#!/bin/bash

## minikube addons enable ingress

### kubectl apply -f namespace.yaml

kubectl apply -f apple.yaml
kubectl apply -f orange.yaml
kubectl apply -f banana.yaml

kubectl apply -f ingress.yaml
kubectl apply -f ingress-orange.yaml


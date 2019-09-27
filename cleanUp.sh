#!/bin/bash

kubectl delete -f ingress-orange.yaml
kubectl delete -f ingress.yaml

kubectl delete -f orange.yaml
kubectl delete -f banana.yaml
kubectl delete -f apple.yaml

kubectl delete -f namespace-marchex.yaml

##minikube addons disable ingress

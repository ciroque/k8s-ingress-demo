#!/bin/bash

function main() {
  clear

  init

  showMessage "Running k8s Ingress demo..."
  askContinue

  showMessage "Ensure Ingress Controller is enabled..."
  minikube addons enable ingress
  askContinue

  showMessage "Here's a list of all the currently defined Services..."
  listResources service
  askContinue

  showMessage "Here's a list of all the currently defined Pods..."
  listResources pod
  askContinue

  showMessage "Here's a list of all the currently defined Ingresses..."
  listResources ingress
  askContinue

  showMessage "Creating apple Service and Pod..."
  createResource "apple.yaml"
  askContinue

  showMessage "Creating banana Service and Pod..."
  createResource "banana.yaml"
  askContinue

  showMessage "Here's the list of all the currently defined Services..."
  listResources service
  askContinue

  showMessage "Here are the details of the apple Service, notice it is of type ClusterIP, not NodePort..."
  describeResource service "apple-service"
  askContinue

  showMessage "Creating the Ingress for the apple and banana Services..."
  createResource "ingress.yaml"
  askContinue

  showMessage "Here are the details of the example-ingress Ingress..."
  describeResource ingress "example-ingress"
  askContinue

  showMessage "We need the IP Address of the Ingress..."
  lookUpIngressIp
  askContinue

  showMessage "Calling the apple Service..."
  getFruitWithRetry apple
  askContinue

  showMessage "Calling the banana Service..."
  getFruitWithRetry banana
  askContinue

  showMessage "Calling the orange Service..."
  getFruitWithRetry orange
  askContinue

  showMessage "Creating the orange Service and Pod..."
  createResource "orange.yaml"
  askContinue

  showMessage "Creating the Ingress for the orange Service..."
  createResource "ingress-orange.yaml"
  askContinue

  showMessage "Here  is the list of the currently defined Ingress resources..."
  listResources ingress
  askContinue

  showMessage "Calling the orange Service..."
  getFruitWithRetry orange
  askContinue

  showMessage "This concludes the demonstration."
  askContinue "continue (all resources will be deleted)?"

  cleanUp
}

function askContinue() {
  echo
  message=${1-"press Enter to continue..."}
  showBar
  echo -e "${NRML}"
  pause $message
  clear
}

function getFruitWithRetry() {
  FRUIT=$1
  curlStatus=`curl -s -o /dev/null -w "%{http_code}" -kL http://$ingress_ip/$FRUIT` > /dev/null
  if [ $curlStatus -eq 200 ] 
  then
    curl -kL http://$ingress_ip/$FRUIT
  else
    read -p "curl failed ($curlStatus), try again?  " yn
    case $yn in
      [Yy] ) getFruitWithRetry $FRUIT;; 
      [Nn] ) ;;
      * ) echo "Please respond with Y, y, N, or n...  "; getFruitWithRetry $FRUIT;;
    esac
  fi
}

function cleanUp() {
  deleteResource "apple.yaml"
  deleteResource "banana.yaml"
  deleteResource "orange.yaml"
  deleteResource "ingress.yaml"
  deleteResource "ingress-orange.yaml"
  minikube addons disable ingress
}

function createResource() {
  kubectl apply -f $1
}

function deleteResource() {
  kubectl delete -f $1
}

function describeResource() {
  kubectl describe $1 $2
}


function init() {
  RED=`tput setaf 1`
  YELLOW=`tput setaf 3`
  BLUE=`tput setaf 4`
  GREEN=`tput setaf 2`

#  BLUE=$RED
#  GREEN=$YELLOW

  WHITE=`tput setaf 7`
  BOLD=`tput smso`
  NRML=`tput rmso`
}

function lookUpIngressIp() {
  iip=""
  while [ -z "$iip" ]
  do
    sleep 1s
    echo "(looking up Ingress IP...)"
    iip=$(kubectl describe ingress example-ingress | grep Address\: | tr -s ' ' | cut -d' ' -f2)
  done
  export ingress_ip=$iip
  echo "THE INGRESS IP IS: $ingress_ip"
}

function listResources() {
  resourceName=$1
  kubectl get $resourceName
}

function pause() {
  read -p "$*"
}

function showBar() {
  echo -e  "${BOLD}${BLUE} - ${GREEN} - ${BLUE} - ${GREEN} - ${BLUE} - ${GREEN} - ${BLUE} - ${GREEN} - ${BLUE} - ${GREEN} - ${BLUE} - ${GREEN} - ${BLUE} - ${GREEN} - ${BLUE} - ${GREEN} - ${BLUE} - ${GREEN} - ${BLUE} - ${GREEN} - ${BLUE} - ${GREEN} - ${BLUE} - ${GREEN} - ${BLUE} - ${GREEN} - ${BLUE} - ${GREEN} - ${BLUE} - ${GREEN} - ${BLUE} - ${GREEN} - ${BLUE} - ${GREEN} - ${BLUE} - ${GREEN} - ${BLUE} - ${GREEN} - ${BLUE} - ${GREEN} - ${BLUE} - ${GREEN} - ${BLUE} - ${GREEN} - ${BLUE} - ${GREEN} - ${BLUE} - ${GREEN} - ${BLUE} - ${GREEN} - ${BLUE} - ${GREEN} - ${BLUE} - ${GREEN} - ${BLUE} - ${GREEN} - ${BLUE} - ${GREEN} - ${BLUE} - ${GREEN}${NRML}"
}

function showMessage() {
  showBar
  echo
  echo -e "${WHITE}$*"
  echo
  showBar
  echo -e "${NRML}${WHITE}"
}

main

#lookUpIngressIp
#getFruitWithRetry orange


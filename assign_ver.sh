#!/bin/bash
#export KUBECONFIG=kubeconfig
touch temp.yaml
sed s/{{BUILD_NUMBER}}/$1/g deployment.yaml > temp.yaml
kubectl apply -f temp.yaml
rm -f temp.yaml

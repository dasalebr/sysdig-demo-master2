#!/bin/bash
#export KUBECONFIG=kubeconfig
#export KEY=$(cat /root/ocp-install/ocp44/auth/kubeadmin-password)
#oc login oc login https://api.ocp4.clouddemos.pe:6443 -u kubeadmin -p $KEY
oc project demo
touch temp.yaml
sed s/{{BUILD_NUMBER}}/$1/g deployment.yaml > temp.yaml
kubectl apply -f temp.yaml
rm -f temp.yaml

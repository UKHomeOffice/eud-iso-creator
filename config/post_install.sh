#!/bin/bash

. image_config/docker
. image_config/kubectl_minikube
. image_config/packer

echo "Installing docker"
  separator
    docker_role
  separator

echo "Installing kubectl / minikube"
  separator
    kubectl_minikube_role
  separator

echo "Installing packer"
  separator
    packer_role
  separator

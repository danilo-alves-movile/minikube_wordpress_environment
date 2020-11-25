#!/bin/bash
set -xe

install_minikube(){
    sudo apt-get install curl apt-transport-https virtualbox virtualbox-ext-pack -y
    wget https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
    sudo cp minikube-linux-amd64 /usr/local/bin/minikube
    sudo chmod 755 /usr/local/bin/minikube
    minikube version
}

start_minikube(){
    minikube start
}

install_kubectl(){
    curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
    chmod +x ./kubectl
    sudo mv ./kubectl /usr/local/bin/kubectl
    kubectl version -o json
}

main(){
    echo -e "\nInstalling Minikube.."
    install_minikube

    echo -e "\nAre you need install kubectl? (N/y)"
    read op
    op_nor="$(echo $op | tr [:upper:] [:lower:])"
    if [[ "$op_nor" == "y" || "$op_nor" == "yes" ]]; then
        install_kubectl
    fi

    echo -e "\nStarting Minikube.."
    start_minikube
}

main

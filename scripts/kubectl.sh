#!/bin/bash


curl -o aws-iam-authenticator https://s3.us-west-2.amazonaws.com/amazon-eks/1.21.2/2021-07-05/bin/linux/amd64/aws-iam-authenticator
curl -o aws-iam-authenticator.sha256 https://s3.us-west-2.amazonaws.com/amazon-eks/1.21.2/2021-07-05/bin/linux/amd64/aws-iam-authenticator.sha256

if sha256sum -c aws-iam-authenticator.sha256; then
    chmod +x aws-iam-authenticator
    sudo mv aws-iam-authenticator /usr/local/bin/aws-iam-authenticator
fi

KUBE_REL=$(curl -L -s https://dl.k8s.io/release/stable.txt)

curl -LO "https://dl.k8s.io/release/${KUBE_REL}/bin/linux/amd64/kubectl"
KUBE_SHA=$(curl -sL "https://dl.k8s.io/release/${KUBE_REL}/bin/linux/amd64/kubectl.sha256")

echo "${KUBE_SHA} kubectl" > kubectl.sha256

if sha256sum -c kubectl.sha256; then
    chmod +x kubectl
    sudo mv kubectl /usr/local/bin/kubectl
fi

CM_RELEASE=$(curl -sL https://api.github.com/repos/cert-manager/cert-manager/releases/latest | jq -r .tag_name)

OS=$(go env GOOS); ARCH=$(go env GOARCH); curl -sSL -o cmctl.tar.gz https://github.com/cert-manager/cert-manager/releases/download/$CM_RELEASE/cmctl-$OS-$ARCH.tar.gz
tar xzf cmctl.tar.gz
sudo mv cmctl /usr/local/bin

OS=$(go env GOOS); ARCH=$(go env GOARCH); curl -sSL -o kubectl-cert-manager.tar.gz https://github.com/cert-manager/cert-manager/releases/download/$CM_RELEASE/kubectl-cert_manager-$OS-$ARCH.tar.gz
tar xzf kubectl-cert-manager.tar.gz
sudo mv kubectl-cert_manager /usr/local/bin

curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
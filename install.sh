###
#
# kubectl plugins
#
###

# krew
(
  set -x; cd "$(mktemp -d)" &&
  OS="$(uname | tr '[:upper:]' '[:lower:]')" &&
  ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" &&
  KREW="krew-${OS}_${ARCH}" &&
  curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" &&
  tar zxvf "${KREW}.tar.gz" &&
  ./"${KREW}" install krew
)

###
#
# Misc
#
###

# minikube
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 \
  && mv minikube ~/.local/bin && chmod +x ~/.local/bin/minikube

# skupper
curl https://skupper.io/install.sh | sh

# kubeseal
VER=0.19.0
wget https://github.com/bitnami-labs/sealed-secrets/releases/download/v$VER/kubeseal-$VER-linux-amd64.tar.gz &&
   tar -xvzf kubeseal-$VER-linux-amd64.tar.gz kubeseal && mv kubeseal ~/.local/bin && rm kubeseal-$VER-linux-amd64.tar.gz

# kubeval
wget https://github.com/instrumenta/kubeval/releases/latest/download/kubeval-linux-amd64.tar.gz && \
  tar xf kubeval-linux-amd64.tar.gz && mv kubeval ~/.local/bin && rm kubeval-linux-amd64.tar.gz

# flux
# trickery with install.sh to install in ~/.local/bin without sudo...
curl -s https://fluxcd.io/install.sh |  (echo "sudo() { \n\$*\n }"; grep -v bash) | bash -s ~/.local/bin

# certmanger cmctl
OS=linux
ARCH=amd64
curl -sSL -o cmctl.tar.gz https://github.com/cert-manager/cert-manager/releases/latest/download/cmctl-$OS-$ARCH.tar.gz && \
	tar xzf cmctl.tar.gz cmctl && mv cmctl ~/.local/bin && rm cmctl.tar.gz


###
#
# Operator Tools
###

# crunchydata pgo
#curl -fsSLO https://github.com/CrunchyData/postgres-operator/releases/download/v4.7.7/pgo && mv pgo ~/.local/bin
curl -fsSLO https://github.com/crunchydata/postgres-operator/releases/latest/download/pgo && mv pgo ~/.local/bin
chmod a+x ~/.local/bin/pgo

# edb cnp
curl -sSfL \
  https://github.com/EnterpriseDB/kubectl-cnp/raw/main/install.sh | \
  sh -s -- -b ~/.local/bin

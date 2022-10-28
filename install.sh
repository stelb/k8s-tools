#!/bin/bash

download() {
	# url
	url=$1
	curl -fsSLO $url
}

tgz() {
	# url file(s)
	url=$1; shift
	files=$*
	tgz=$(basename $url)

	TMP=$(mktemp -d)
	cd $TMP

	download $url &&
		tar zxvf $tgz $files &&
		mv $files ~/.local/bin &&

	cd -
	rm -rf $TMP
}

bin() {
	# url file(s)
	url=$1; shift
	name=$1
	bin=$(basename $url)

	TMP=$(mktemp -d)
	cd $TMP

	download $url &&
		mv $bin ~/.local/bin/${name} &&
		chmod a+x ~/.local/bin/${name}

	cd -
	rm -rf $TMP
}

latest() {
	ghrepo=$1
	curl -sIL https://github.com/${ghrepo}/releases/latest/download/  | grep location: | cut -d ' ' -f 2 | sed -e 's#.*/v##' | tr -d '\r'
}

###
#
# kubectl plugins
#
###


#tgz https://github.com/kubernetes-sigs/krew/releases/latest/download/krew-linux_amd64.tar.gz ./krew-linux_amd64
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
bin https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 minikube

# kind
bin https://kind.sigs.k8s.io/dl/v0.16.0/kind-linux-amd64 kind

# minishift
VER=$(latest minishift/minishift)
tgz https://github.com/minishift/minishift/releases/download/${VER}/minishift-${VER}-linux-amd64.tgz minishift-${VER}-linux-amd64/minishift

# skupper
curl https://skupper.io/install.sh | sh

# kubeseal
VER=$(latest bitnami-labs/sealed-secrets)
tgz https://github.com/bitnami-labs/sealed-secrets/releases/download/v${VER}/kubeseal-${VER}-linux-amd64.tar.gz kubeseal

# kubeval
tgz https://github.com/instrumenta/kubeval/releases/latest/download/kubeval-linux-amd64.tar.gz kubeval

# polaris
tgz https://github.com/FairwindsOps/polaris/releases/latest/download/polaris_linux_amd64.tar.gz polaris

# flux
# trickery with install.sh to install in ~/.local/bin without sudo...
curl -s https://fluxcd.io/install.sh |  (echo "sudo() { \n\$*\n }"; grep -v bash) | bash -s ~/.local/bin

# certmanger cmctl
tgz https://github.com/cert-manager/cert-manager/releases/latest/download/cmctl-linux-amd64.tar.gz cmctl


###
#
# Operator Tools
#
###

# olm operator-sdk
bin https://github.com/operator-framework/operator-sdk/releases/download/v1.24.1/operator-sdk_linux_amd64 operator-sdk

# crunchydata pgo
bin https://github.com/crunchydata/postgres-operator/releases/latest/download/pgo pgo

# edb cnp
curl -sSfL \
  https://github.com/EnterpriseDB/kubectl-cnp/raw/main/install.sh | \
  sh -s -- -b ~/.local/bin

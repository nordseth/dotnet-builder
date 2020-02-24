FROM mcr.microsoft.com/dotnet/core/sdk:3.1 

ARG HELM_VERSION="v3.1.1"
ARG KUBE_VERSION="1.17.3"

RUN apt-get update -q \
    && apt-get install -y software-properties-common apt-transport-https curl \
    # add kubectl
    && curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - \
    && apt-add-repository --yes --update "deb https://apt.kubernetes.io/ kubernetes-xenial main" \
    && apt-get install -y kubectl=$KUBE_VERSION-00 \
    # helm
    && wget https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz \
    && tar -xvf helm-${HELM_VERSION}-linux-amd64.tar.gz \
    && mv linux-amd64/helm /usr/local/bin \
    && rm -f /helm-${HELM_VERSION}-linux-amd64.tar.gz \
    && helm repo add stable https://kubernetes-charts.storage.googleapis.com/ \
    # cleanup
    && rm -rf /var/lib/apt/lists/*

ARG NIBBLER_VERSION="1.0.0-rc.2"

RUN dotnet tool install --global Nibbler --version $NIBBLER_VERSION
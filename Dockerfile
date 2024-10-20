ARG HELM_VERSION=3.16.2
ARG TARGETOS=linux
ARG TARGETARCH=amd64

FROM alpine
ARG HELM_VERSION
ARG TARGETOS
ARG TARGETARCH

RUN apk update; \
    apk upgrade --available; \
    set -eux; \
	  apk add --no-cache \
      wget \
      ca-certificates \
      curl \
      make \
      jq \
      python3 \
      py3-pip \
      ansible \
      py3-kubernetes

RUN pip3 install --no-cache --break-system-packages --upgrade pip; \
    pip3 install --no-cache --break-system-packages pip-review; \
    pip-review --local --auto

RUN wget -q https://get.helm.sh/helm-v${HELM_VERSION}-${TARGETOS}-${TARGETARCH}.tar.gz -O - | tar -xzO ${TARGETOS}-${TARGETARCH}/helm > /usr/local/bin/helm \
    ; \
    chmod +x /usr/local/bin/helm; \
    mkdir /config ;\
    chmod g+rwx /config /root ;\
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"; \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl; \
    helm repo add "stable" "https://charts.helm.sh/stable" --force-update \
    && kubectl version --client \
    && helm version

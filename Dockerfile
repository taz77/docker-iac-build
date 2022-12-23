ARG APK_MAIN=https://dl-cdn.alpinelinux.org/alpine/v3.16/main
ARG APK_COMMUNITY=https://dl-cdn.alpinelinux.org/alpine/v3.16/community
ARG HELM_VERSION=3.7.1
ARG TARGETOS=linux
ARG TARGETARCH=amd64

FROM willhallonline/ansible:alpine
ARG APK_MAIN
ARG APK_COMMUNITY
ARG HELM_VERSION
ARG TARGETOS
ARG TARGETARCH
ENV APK_MAIN=${APK_MAIN} \
    APK_COMMUNITY=${APK_COMMUNITY}



RUN rm /etc/apk/repositories; \
    echo $APK_MAIN > /etc/apk/repositories; \
    echo $APK_COMMUNITY >> /etc/apk/repositories; \
    cat /etc/apk/repositories

RUN apk upgrade; \
    apk upgrade --available; \
#    set -eux; \
	  apk add --no-cache \
      wget \
      ca-certificates \
      curl \
      make

RUN wget -q https://get.helm.sh/helm-v${HELM_VERSION}-${TARGETOS}-${TARGETARCH}.tar.gz -O - | tar -xzO ${TARGETOS}-${TARGETARCH}/helm > /usr/local/bin/helm \
    ; \
    chmod +x /usr/local/bin/helm; \
    mkdir /config ;\
    chmod g+rwx /config /root ;
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"; \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
RUN helm repo add "stable" "https://charts.helm.sh/stable" --force-update \
    && kubectl version --client \
    && helm version

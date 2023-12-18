ARG IMAGE_NAME="debian"
ARG IMAGE_TAG="stable-slim"
FROM ${IMAGE_NAME}:${IMAGE_TAG}

WORKDIR /root

ENV HOME="/root"
ENV PATH="$HOME/.tfenv/bin:$HOME/.tgenv/bin:/usr/local/bin:$PATH"

RUN set -eux \
    && apt update && \
    apt install -y \
    bash \
    bzip2 \
    ca-certificates \
    coreutils \
    curl \
    findutils \
    git \
    git-crypt \
    gzip \
    jq \
    pigz \
    tar \
    unzip \
    xz-utils \
    zip \
    && git clone --depth 1 https://github.com/tfutils/tfenv.git ~/.tfenv \
    && git clone --depth 1 https://github.com/tgenv/tgenv.git ~/.tgenv \
    && echo 'PATH=${HOME}/.tfenv/bin:${HOME}/.tgenv/bin:/usr/local/bin:${PATH}' >> ~/.bashrc \
    && curl -fsSLo /usr/local/bin/kubectl  \
        "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
    && curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"  | bash \
    && export VERIFY_CHECKSUM=false \
    && curl -s https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash \
    && unset VERIFY_CHECKSUM \
    && chmod +x /usr/local/bin/kubectl \
    && sed -i -e "s/bin\/ash/bin\/bash/" /etc/passwd \
    && ln -sf /bin/bash /bin/sh \
    && rm -rf /var/lib/apt/lists/*

ENV TF_VERSION=1.5.4
RUN curl -L https://raw.githubusercontent.com/warrensbox/terraform-switcher/release/install.sh | bash \
    && tfswitch ${TF_VERSION}
 
ENV TG_VERSION=0.48.6
RUN curl -L https://raw.githubusercontent.com/warrensbox/tgswitch/release/install.sh | bash \
    && tgswitch ${TG_VERSION}

RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

ENTRYPOINT ["/bin/bash", "-c"]
CMD ["/bin/bash", "-c"]

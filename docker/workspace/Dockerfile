ARG DEBIAN_VERSION=13

FROM debian:${DEBIAN_VERSION}

ENV DEBIAN_FRONTEND noninteractive

RUN apt update &&  \
    apt install -y openjdk-25-jdk python3 ansible jq curl

RUN case "$(uname -m)" in \
        aarch64) ARCH="aarch64" ;; \
        x86_64)  ARCH="i686"    ;; \
        *) echo "Arquitectura no soportada: $(uname -m)" && exit 1 ;; \
    esac && \
    VERSION=$(curl -s https://api.github.com/repos/vi/websocat/releases/latest | jq -r '.tag_name') && \
    curl -L "https://github.com/vi/websocat/releases/download/${VERSION}/websocat.${ARCH}-unknown-linux-musl" \
         -o /usr/local/bin/websocat && \
    chmod +x /usr/local/bin/websocat

RUN VERSION=$(curl -s https://api.github.com/repos/besu-eth/besu/releases/latest | jq -r '.tag_name' | sed 's/^v//') && \
    curl -L "https://github.com/besu-eth/besu/releases/download/${VERSION}/besu-${VERSION}.tar.gz" \
         -o /tmp/besu.tar.gz && \
    tar -xzf /tmp/besu.tar.gz -C /tmp && \
    mv /tmp/besu-${VERSION} /usr/local/besu && \
    rm /tmp/besu.tar.gz

ENV PATH="/usr/local/besu/bin:${PATH}"

WORKDIR /blockchain

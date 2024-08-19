# Définir des arguments de build pour l'architecture et le système d'exploitation cibles
ARG TARGETOS
ARG TARGETARCH

FROM chdotworld/dotworld:base-alpine

LABEL maintainer="Dotworld"

ARG GOLANG_VERSION=1.22.5

USER root

RUN apk update \
  && apk upgrade \
  && apk add --no-cache docker-cli go gcc bash musl-dev openssl-dev ca-certificates neofetch \
  && update-ca-certificates \
  && rm -rf /var/cache/apk/*

RUN wget https://dl.google.com/go/go$GOLANG_VERSION.src.tar.gz && tar -C /usr/local -xzf go$GOLANG_VERSION.src.tar.gz

RUN cd /usr/local/go/src && ./make.bash

ENV PATH=$PATH:/usr/local/go/bin

RUN rm go$GOLANG_VERSION.src.tar.gz

#we delete the apk installed version to avoid conflict
RUN apk del go

RUN go version

RUN curl -sSf https://atlasgo.sh | sh

COPY --from=golangci/golangci-lint /usr/bin/golangci-lint /usr/bin/golangci-lint

# Set working directory
WORKDIR /var/www/html

# Install Air
RUN go install github.com/cosmtrek/air@latest
COPY go.mod go.sum ./
RUN go mod download

CMD ["air", "-c", ".air.toml"]
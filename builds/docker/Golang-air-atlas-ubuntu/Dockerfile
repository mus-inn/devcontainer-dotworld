FROM --platform=$BUILDPLATFORM chdotworld/dotworld:node22-ubuntu

ARG TARGETOS
ARG TARGETARCH

RUN echo "Building for architecture: $TARGETARCH"

WORKDIR /app

LABEL maintainer="Dotworld"

# Run package updates and install dependencies
RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get install -y curl ca-certificates && \
    rm -rf /var/lib/apt/lists/*

## Install golang
RUN curl -LO https://go.dev/dl/go1.23.0.linux-${TARGETARCH}.tar.gz && \
    tar -xvf go1.23.0.linux-${TARGETARCH}.tar.gz -C /usr/local && \
    rm go1.23.0.linux-${TARGETARCH}.tar.gz

# Set environment variable for Go
ENV PATH="/usr/local/go/bin:${PATH}"

# Install air via Go
RUN go install github.com/air-verse/air@latest

# Show go version to verify installation
RUN go version

# Install Atlas CLI
RUN curl -sSf https://atlasgo.sh | sh

# For golangci-lint, as the FROM instruction for copying is removed, pull it in by another method.
# Install golangci-lint
RUN curl -sSfL https://github.com/golangci/golangci-lint/releases/download/v1.50.0/golangci-lint-1.50.0-linux-${TARGETARCH}.tar.gz | tar -xzO golangci-lint-1.50.0-linux-${TARGETARCH}/golangci-lint > /usr/bin/golangci-lint && \
    chmod +x /usr/bin/golangci-lint

# Set the command to run air with configuration file
CMD ["/root/go/bin/air", "-c", ".air.toml"]
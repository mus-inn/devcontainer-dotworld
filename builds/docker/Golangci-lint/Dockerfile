FROM golangci/golangci-lint:v1.57.2 AS golangci-lint

RUN golangci-lint --version

FROM golang:1.22

RUN curl -sSfL https://raw.githubusercontent.com/cosmtrek/air/master/install.sh | sh -s -- -b $(go env GOPATH)/bin
RUN curl -sSf https://atlasgo.sh | sh
RUN go install github.com/golangci/golangci-lint/cmd/golangci-lint@v1.57.2

RUN apt-get update && apt-get install -y git zsh curl wget vim

RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

COPY builds/.zshrc /root/.zshrc

WORKDIR /app

ENTRYPOINT ["zsh"]

FROM golang:1.16.5-stretch

WORKDIR /go/src/github.com/giwa/isucon11p
COPY . ./
RUN curl -sSfL https://raw.githubusercontent.com/cosmtrek/air/master/install.sh | sh -s -- -b $(go env GOPATH)/bin

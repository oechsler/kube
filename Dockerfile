FROM golang:1.19 as build

ENV GO111MODULE=on \
	CGO_ENABLED=0 \
	GOOS=linux

WORKDIR /build

# Install and cache dependencies
COPY go.mod .
COPY go.sum .
RUN go mod download

# Copy the source code
COPY . .

# Build the binary
RUN go build -o ./out/kube .

FROM alpine:latest

WORKDIR /root

COPY --from=build /build/out/kube /opt/kube

ENTRYPOINT [ "/opt/kube" ]
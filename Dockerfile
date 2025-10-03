# Builder container
FROM golang:latest AS builder

WORKDIR /go/src
COPY main.go .

## Ensures that built binary is static
RUN GO111MODULE=auto CGO_ENABLED=1 GOOS=linux go build \
	-a -tags netgo -ldflags '-w -extldflags "-static"' \
	-o internyet_proxy
	
RUN GO111MODULE=auto CGO_ENABLED=1 GOOS=linux GOARCH=arm64 go build \
	-a -tags netgo -ldflags '-w -extldflags "-static"' \
	-o internyet_proxy.arm64

# Runtime container
FROM scratch

WORKDIR /
COPY --from=builder /go/src/internyet_proxy .
COPY --from=builder /go/src/internyet_proxy.arm64 .

USER 10000
ENTRYPOINT ["/internyet_proxy"]
CMD ["-env"]

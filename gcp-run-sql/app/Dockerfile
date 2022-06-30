FROM golang:1.18 AS builder
WORKDIR /go/workspace
COPY . .
RUN GOOS=linux GOARCH=amd64 go build cmd/server.go

FROM busybox
COPY --from=builder /go/workspace/server /server
EXPOSE 8080
CMD ["/server"]
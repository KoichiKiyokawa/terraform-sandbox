FROM golang:1.18 AS builder
WORKDIR /go/workspace
COPY . .
RUN GOOS=linux GOARCH=amd64 go build cmd/server.go

FROM alpine
COPY --from=builder /go/workspace/server /
EXPOSE 8080
CMD ["/server"]
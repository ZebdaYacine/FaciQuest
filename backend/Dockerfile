FROM golang:1.22.0 AS builder

WORKDIR /app

COPY go.*  ./

RUN go mod download

COPY . ./

COPY .env ./

RUN go build -o main cmd/main.go

# FROM alpine:latest

# WORKDIR /app

EXPOSE 9000

CMD ["/app/main"]
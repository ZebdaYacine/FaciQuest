# Use the official Go image to build the Go application
FROM golang:1.22.0 AS builder

RUN mkdir /app

ADD . /app

WORKDIR /app

COPY go.mod go.sum ./

RUN go mod download

RUN go mod tidy

COPY . ./app


RUN go build -o main cmd/main.go

EXPOSE 9000

CMD ["/app/main"]




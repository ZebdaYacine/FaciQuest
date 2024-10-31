FROM golang:1.22.0

WORKDIR /usr/src/app


COPY go.mod go.sum  ./

RUN go mod download
RUN go mod tidy

COPY . ./

COPY .env ./


EXPOSE 3000

WORKDIR /usr/src/app/cmd

CMD ["go","run","main.go"]
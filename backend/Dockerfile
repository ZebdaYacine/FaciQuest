# FROM golang:1.22.0

# WORKDIR /usr/src/app


# COPY go.mod go.sum  ./

# RUN go mod download
# RUN go mod tidy

# COPY . ./

# COPY .env ./


# EXPOSE 3000

# WORKDIR /usr/src/app/cmd

# CMD ["go","run","main.go"]

# Use Go base image
FROM golang:1.22.0

# Set the working directory
WORKDIR /usr/src/app

# Copy go.mod and go.sum first to cache dependencies
COPY go.mod go.sum ./

# Download dependencies
RUN go mod download
RUN go mod tidy

# Copy the rest of the application code, including the .env file
COPY . .

# Expose the application port
EXPOSE 3000

# Set the working directory to the command directory if needed
WORKDIR /usr/src/app/cmd

# Run the application
CMD ["go", "run", "main.go"]

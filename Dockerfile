# Build
FROM golang:alpine AS build

RUN apk add --no-cache -U build-base git make protobuf protobuf-dev \
  && go get -u github.com/golang/protobuf/protoc-gen-go

WORKDIR /src

COPY . .

RUN /bin/sh -c "[ -f Makefile ] && make || go build"

# Runtime
FROM golang:alpine

RUN apk --no-cache -U add git build-base ffmpeg ffmpeg-dev \
  && go get github.com/mutschler/mt

COPY --from=build /src/tube /tube

ENTRYPOINT ["/tube"]

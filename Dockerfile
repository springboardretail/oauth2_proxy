FROM golang:1.9 AS builder

RUN go get github.com/golang/dep/cmd/dep
WORKDIR /go/src/github.com/bitly/oauth2_proxy
COPY Gopkg.* ./
RUN dep ensure -vendor-only
COPY . /go/src/github.com/bitly/oauth2_proxy/
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo .

FROM alpine:latest

RUN apk --no-cache add ca-certificates
COPY --from=builder /go/src/github.com/bitly/oauth2_proxy/oauth2_proxy /usr/bin/

USER nobody

ENTRYPOINT ["/usr/bin/oauth2_proxy"]

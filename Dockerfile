############# builder            #############
FROM golang:1.15.0 AS builder

WORKDIR /go/src/github.com/gardener/cloud-provider-aws
COPY . .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go install \
  -mod=vendor \
  ./...

############# base               #############
FROM alpine:3.12.0 AS base

RUN apk add --update bash curl

WORKDIR /

############# cloud-provider-aws #############
FROM base AS cloud-provider-aws

COPY --from=builder /go/bin/aws-cloud-controller-manager /aws-cloud-controller-manager

ENTRYPOINT ["/aws-cloud-controller-manager"]

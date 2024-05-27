# syntax=docker/dockerfile:1
ARG PARENT_IMG
FROM golang:1.22.2-bullseye@sha256:3b55bf3986b2651a515f48ddf758b80a7d78d8be18706fd98aa74241992dac96 as build-env
WORKDIR /src
COPY app.go ./main.go
RUN CGO_ENABLED=0 go build -o /bin/hello ./main.go
#checkov:skip=CKV_DOCKER_7:PARENT_IMAGE_build_arg_has_SHA_hash
ARG PARENT_IMG
FROM ${PARENT_IMG}
#FROM gcr.io/distroless/static-debian12@sha256:8cbe18a8a9a9fefe70590dc8f6a7bc70b4bbe41f262d9dab9084337adabf6d26
EXPOSE 3333/tcp
COPY --from=build-env /bin/hello /bin/hello
#COPY eicar.txt .
COPY <<EOF /etc/passwd
nobody:x:65534:65534:Nobody:/:
EOF
COPY <<EOF /etc/group
nobody:x:65534:nobody
EOF
USER nobody
ENTRYPOINT ["/bin/hello"]

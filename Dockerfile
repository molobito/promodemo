# syntax=docker/dockerfile:1
FROM cgr.dev/chainguard/go@sha256:367ea43de6060d05619b582d7252c8da4f7384e8580097aa61c108c9ffee9d3e AS build-env
WORKDIR /src
COPY <<EOF ./main.go
package main
import "fmt"
func main() {
  fmt.Println("hello, world")
}
EOF
RUN CGO_ENABLED=0 go build -o /bin/hello ./main.go
FROM cgr.dev/chainguard/static@sha256:d6a97eb401cbc7c6d48be76ad81d7899b94303580859d396b52b67bc84ea7345
COPY --from=build-env /bin/hello /bin/hello
COPY <<EOF /etc/passwd
nobody:x:65534:65534:Nobody:/:
EOF
COPY <<EOF /etc/group
nobody:x:65534:nobody
EOF
USER nobody
ENTRYPOINT ["/bin/hello"]

package main

import (
        "fmt"
        "io"
        "os"
        "errors"
        "net/http"
)

func getRoot(w http.ResponseWriter, r *http.Request) {
        fmt.Printf("got / request\\n")
        io.WriteString(w, "<h1>This is my GO website!</h1>")
}
func getHello(w http.ResponseWriter, r *http.Request) {
        fmt.Printf("got /hello request\\n")
        io.WriteString(w, "Hello, BUDDY!")
}
func main() {
	http.HandleFunc("/", getRoot)
	http.HandleFunc("/hello", getHello)

	err := http.ListenAndServe(":3333", nil)
  if errors.Is(err, http.ErrServerClosed) {
		fmt.Printf("server closed\\n")
	} else if err != nil {
		fmt.Printf("error starting server: %s\\n", err)
		os.Exit(1)
	}
}

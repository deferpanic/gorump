package main

import (
        "fmt"
        "net/http"
	"C"
)

// fast test
func fastHandler(w http.ResponseWriter, r *http.Request) {
        fmt.Fprintf(w, "this request is fast")
}

func main () { httpd() }

//export httpd
func httpd() {
        http.HandleFunc("/fast", fastHandler)

        http.ListenAndServe(":3000", nil)
}

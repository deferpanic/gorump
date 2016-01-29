package main

import "C"

import "fmt"
import "bytes"
import . "github.com/op/go-nanomsg"

func main() {
}

//export nano_example
func nano_example() {
	fmt.Println("Hello, Rumprun.  This is a nanomsg example.")
	var err error
	var rep, req *Socket
	socketAddress := "inproc://a"

	if rep, err = NewSocket(AF_SP, REP); err != nil {
		fmt.Println(err)
	}
	if _, err = rep.Bind(socketAddress); err != nil {
		fmt.Println(err)
	}
	if req, err = NewSocket(AF_SP, REQ); err != nil {
		fmt.Println(err)
	}
	if _, err = req.Connect(socketAddress); err != nil {
		fmt.Println(err)
	}

	if _, err = req.Send([]byte("ABC"), 0); err != nil {
		fmt.Println(err)
	}
	if data, err := rep.Recv(0); err != nil {
		fmt.Println(err)
	} else if bytes.Compare(data, []byte("ABC")) != 0 {
		fmt.Println(err)
	} else {
		fmt.Println("Success getting data:", string(data))
	}

	if err = rep.Close(); err != nil {
		fmt.Println(err)
	}
	if err = req.Close(); err != nil {
		fmt.Println(err)
	}
}

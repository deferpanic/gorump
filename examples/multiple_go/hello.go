package main

import "fmt"
import "C"

func main() {
}

//export damain
func damain() {
	fmt.Println("Hello, Rumprun.  This is Go.")
	AnotherFunction()
}

package main

import (
	"C"
	"bytes"
	"fmt"
	"runtime/debug"
	"strconv"
)

func main() {
}

//export damain
func damain() {
	var buffer bytes.Buffer
	var gc debug.GCStats

	var lastgc int64

	buffer.Write(make([]byte, 0, 1000000*5))

	debug.ReadGCStats(&gc)
	gcs := strconv.FormatInt(gc.NumGC, 10)
	fmt.Printf("gcs:%v\n", gcs)
	lastgc = gc.LastGC.UnixNano()
	fmt.Printf("lastgc:%v\n", lastgc)
}

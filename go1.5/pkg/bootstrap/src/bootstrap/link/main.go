// Do not edit. Bootstrap copy of /home/eyberg/go/src/github.com/deferpanic/gorump/go/src/cmd/link/main.go

//line /home/eyberg/go/src/github.com/deferpanic/gorump/go/src/cmd/link/main.go:1
// Copyright 2015 The Go Authors.  All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package main

import (
	"bootstrap/internal/obj"
	"bootstrap/link/internal/amd64"
	"bootstrap/link/internal/arm"
	"bootstrap/link/internal/arm64"
	"bootstrap/link/internal/ppc64"
	"bootstrap/link/internal/x86"
	"fmt"
	"os"
)

func main() {
	switch obj.Getgoarch() {
	default:
		fmt.Fprintf(os.Stderr, "link: unknown architecture %q\n", obj.Getgoarch())
		os.Exit(2)
	case "386":
		x86.Main()
	case "amd64", "amd64p32":
		amd64.Main()
	case "arm":
		arm.Main()
	case "arm64":
		arm64.Main()
	case "ppc64", "ppc64le":
		ppc64.Main()
	}
}

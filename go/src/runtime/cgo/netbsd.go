// Copyright 2010 The Go Authors.  All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

// +build netbsd

package cgo

import _ "unsafe" // for go:linkname

// Supply environ and __progname, because we don't
// link against the standard NetBSD crt0.o and the
// libc dynamic library needs them.

//go:linkname _environ environ
//go:linkname _progname __progname

var _environ uintptr
var _progname uintptr


// various C symbols needed by Rumprun

//go:cgo_import_static rump_syscall

//go:cgo_import_static _mmap
//go:cgo_import_static munmap
//go:cgo_import_static _exit

//go:cgo_import_static _lwp_self
//go:cgo_import_static ___lwp_park60
//go:cgo_import_static _lwp_unpark

//go:cgo_import_static _sys_open
//go:cgo_import_static _sys_read
//go:cgo_import_static _sys_write
//go:cgo_import_static _sys_fcntl
//go:cgo_import_static _sys_close
//go:cgo_import_static _sys___clock_gettime50
//go:cgo_import_static _sys___nanosleep50

//go:cgo_import_static kludge_argc
//go:cgo_import_static kludge_argv

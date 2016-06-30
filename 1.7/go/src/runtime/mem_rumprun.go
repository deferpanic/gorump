// Copyright 2010 The Go Authors.  All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

// +build dragonfly freebsd nacl netbsd openbsd solaris rumprun

package runtime

import "unsafe"

// Don't split the stack as this function may be invoked without a valid G,
// which prevents us from allocating more stack.
//go:nosplit
func sysAlloc(n uintptr, sysStat *uint64) unsafe.Pointer {
	v := unsafe.Pointer(mmap(nil, n, _PROT_READ|_PROT_WRITE, _MAP_ANON|_MAP_PRIVATE, -1, 0))
	if uintptr(v) < 4096 {
		return nil
	}
	mSysStatInc(sysStat, n)
	return v
}

func sysUnused(v unsafe.Pointer, n uintptr) {
	madvise(v, n, _MADV_FREE)
}

func sysUsed(v unsafe.Pointer, n uintptr) {
}

// Don't split the stack as this function may be invoked without a valid G,
// which prevents us from allocating more stack.
//go:nosplit
func sysFree(v unsafe.Pointer, n uintptr, sysStat *uint64) {
	mSysStatDec(sysStat, n)
	munmap(v, n)
}

func sysFault(v unsafe.Pointer, n uintptr) {
	// XXX this will most likely not work as expected on Rumprun (?)
	mmap(v, n, _PROT_NONE, _MAP_ANON|_MAP_PRIVATE|_MAP_FIXED, -1, 0)
}

func sysReserve(v unsafe.Pointer, n uintptr, reserved *bool) unsafe.Pointer {
	p := unsafe.Pointer(mmap(v, n, _PROT_READ|_PROT_WRITE,
		_MAP_ANON|_MAP_PRIVATE, -1, 0))
	if uintptr(p) < 4096 {
		panic("unable to allocate runtime memory")
	}
	*reserved = true
	return p
}

func sysMap(v unsafe.Pointer, n uintptr, reserved bool, sysStat *uint64) {
	// we already allocated backing memory in sysReserve
	mSysStatInc(sysStat, n)
}

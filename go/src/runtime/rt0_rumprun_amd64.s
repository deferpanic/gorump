// Copyright 2009 The Go Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

#include "textflag.h"

TEXT _rt0_amd64_rumprun(SB),NOSPLIT,$-8
	LEAQ	8(SP), SI // argv
	MOVQ	0(SP), DI // argc
	MOVQ	$main(SB), AX
	JMP	AX

TEXT _rt0_amd64_rumprun_lib(SB),NOSPLIT,$40
	// Create a new thread to do the runtime initialization and return.
	MOVQ    _cgo_sys_thread_create(SB), AX
	TESTQ   AX, AX
	JZ      nocgo
	MOVQ    $_rt0_amd64_rumprun_lib_go(SB), DI
	MOVQ    $0, SI
	CALL    AX
	RET

nocgo:
	// XXX: should just panic here
	RET

TEXT _rt0_amd64_rumprun_lib_go(SB),NOSPLIT,$0
	// XXX: we need a better way to pass argc/argv, but they're not
	// available on Rumprun when this is called, so we leave it to
	// the client to hardcode/fake
        MOVQ    kludge_argc(SB), DI
        LEAQ    kludge_argv(SB), SI
        MOVQ    $runtime·rt0_go(SB), AX
        JMP     AX

TEXT main(SB),NOSPLIT,$-8
	MOVQ	$runtime·rt0_go(SB), AX
	JMP	AX

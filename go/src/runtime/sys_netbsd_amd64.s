// Copyright 2009 The Go Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
//
// System calls and other sys.stuff for AMD64, NetBSD
// /usr/src/sys/kern/syscalls.master for syscall numbers.
//

#include "go_asm.h"
#include "go_tls.h"
#include "textflag.h"

// int32 lwp_create(void *context, uintptr flags, void *lwpid)
// XXXTODO
TEXT runtime·lwp_create(SB),NOSPLIT,$0
	MOVQ	ctxt+0(FP), DI
	MOVQ	flags+8(FP), SI
	MOVQ	lwpid+16(FP), DX
	MOVL	$309, AX		// sys__lwp_create
	SYSCALL
	JCC	2(PC)
	NEGQ	AX
	MOVL	AX, ret+24(FP)
	RET

// XXXTODO
TEXT runtime·lwp_tramp(SB),NOSPLIT,$0
	
	// Set FS to point at m->tls.
	LEAQ	m_tls(R8), DI
	CALL	runtime·settls(SB)

	// Set up new stack.
	get_tls(CX)
	MOVQ	R8, g_m(R9)
	MOVQ	R9, g(CX)
	CALL	runtime·stackcheck(SB)

	// Call fn
	CALL	R12

	// It shouldn't return.  If it does, exit.
	MOVL	$310, AX		// sys__lwp_exit
	SYSCALL
	JMP	-3(PC)			// keep exiting

// XXXTODO
TEXT runtime·osyield(SB),NOSPLIT,$0
	MOVL	$350, AX		// sys_sched_yield
	SYSCALL
	RET

TEXT runtime·lwp_park(SB),NOSPLIT,$0
	MOVQ	abstime+0(FP), DI		// arg 1 - abstime
	MOVL	unpark+8(FP), SI		// arg 2 - unpark
	MOVQ	hint+16(FP), DX		// arg 3 - hint
	MOVQ	unparkhint+24(FP), CX		// arg 4 - unparkhint
	LEAQ	___lwp_park60(SB), AX
	CALL	AX
	MOVL	AX, ret+32(FP)
	RET

TEXT runtime·lwp_unpark(SB),NOSPLIT,$0
	MOVL	lwp+0(FP), DI		// arg 1 - lwp
	MOVQ	hint+8(FP), SI		// arg 2 - hint
	LEAQ	_lwp_unpark(SB), AX
	CALL	AX
	MOVL	AX, ret+16(FP)
	RET

TEXT runtime·lwp_self(SB),NOSPLIT,$0
	LEAQ	_lwp_self(SB), AX
	CALL	AX
	MOVL	AX, ret+0(FP)
	RET

// Exit the entire program (like C exit)
// XXXTODO
TEXT runtime·exit(SB),NOSPLIT,$-8
	MOVL	code+0(FP), DI		// arg 1 - exit status
	MOVL	$1, AX			// sys_exit
	SYSCALL
	MOVL	$0xf1, 0xf1		// crash
	RET

// XXXTODO
TEXT runtime·exit1(SB),NOSPLIT,$-8
	MOVL	$310, AX		// sys__lwp_exit
	SYSCALL
	MOVL	$0xf1, 0xf1		// crash
	RET

TEXT runtime·open(SB),NOSPLIT,$-8
	MOVQ	name+0(FP), DI		// arg 1 pathname
	MOVL	mode+8(FP), SI		// arg 2 flags
	MOVL	perm+12(FP), DX		// arg 3 mode
	LEAQ	_sys_open(SB), AX
	CALL	AX
	JCC	2(PC)
	MOVL	$-1, AX
	MOVL	AX, ret+16(FP)
	RET

TEXT runtime·closefd(SB),NOSPLIT,$-8
	MOVL	fd+0(FP), DI		// arg 1 fd
	LEAQ	_sys_close(SB), AX
	CALL	AX
	JCC	2(PC)
	MOVL	$-1, AX
	MOVL	AX, ret+8(FP)
	RET

TEXT runtime·read(SB),NOSPLIT,$-8
	MOVL	fd+0(FP), DI		// arg 1 fd
	MOVQ	p+8(FP), SI		// arg 2 buf
	MOVL	n+16(FP), DX		// arg 3 count
	LEAQ	_sys_read(SB), AX
	CALL	AX
	JCC	2(PC)
	MOVL	$-1, AX
	MOVL	AX, ret+24(FP)
	RET

TEXT runtime·write(SB),NOSPLIT,$-8
	MOVQ	fd+0(FP), DI		// arg 1 - fd
	MOVQ	p+8(FP), SI		// arg 2 - buf
	MOVL	n+16(FP), DX		// arg 3 - nbyte
	MOVL	$4, AX			// sys_write
	LEAQ	_sys_write(SB), AX
	CALL	AX
	JCC	2(PC)
	MOVL	$-1, AX
	MOVL	AX, ret+24(FP)
	RET

TEXT runtime·usleep(SB),NOSPLIT,$16
	MOVL	$0, DX
	MOVL	usec+0(FP), AX
	MOVL	$1000000, CX
	DIVL	CX
	MOVQ	AX, 0(SP)		// tv_sec
	MOVL	$1000, AX
	MULL	DX
	MOVQ	AX, 8(SP)		// tv_nsec

	MOVQ	SP, DI			// arg 1 - rqtp
	MOVQ	$0, SI			// arg 2 - rmtp
	LEAQ	_sys___nanosleep50(SB), AX
	CALL	AX
	RET

TEXT runtime·raise(SB),NOSPLIT,$16
	RET

TEXT runtime·raiseproc(SB),NOSPLIT,$16
	RET

// XXXTODO (can't fix?)
TEXT runtime·setitimer(SB),NOSPLIT,$-8
	MOVL	mode+0(FP), DI		// arg 1 - which
	MOVQ	new+8(FP), SI		// arg 2 - itv
	MOVQ	old+16(FP), DX		// arg 3 - oitv
	MOVL	$425, AX		// sys_setitimer
	SYSCALL
	RET

// func now() (sec int64, nsec int32)
TEXT time·now(SB), NOSPLIT, $32
	MOVQ	$0, DI			// arg 1 - clock_id
	LEAQ	8(SP), SI		// arg 2 - tp
	LEAQ	_sys___clock_gettime50(SB), AX
	CALL	AX
	MOVQ	8(SP), AX		// sec
	MOVL	16(SP), DX		// nsec

	// sec is in AX, nsec in DX
	MOVQ	AX, sec+0(FP)
	MOVL	DX, nsec+8(FP)
	RET

TEXT runtime·nanotime(SB),NOSPLIT,$32
	MOVQ	$0, DI			// arg 1 - clock_id
	LEAQ	8(SP), SI		// arg 2 - tp
	LEAQ	_sys___clock_gettime50(SB), AX
	CALL	AX
	MOVQ	8(SP), AX		// sec
	MOVL	16(SP), DX		// nsec

	// sec is in AX, nsec in DX
	// return nsec in AX
	IMULQ	$1000000000, AX
	ADDQ	DX, AX
	MOVQ	AX, ret+0(FP)
	RET

// XXXTODO
TEXT runtime·getcontext(SB),NOSPLIT,$-8
	MOVQ	ctxt+0(FP), DI		// arg 1 - context
	MOVL	$307, AX		// sys_getcontext
	SYSCALL
	JCC	2(PC)
	MOVL	$0xf1, 0xf1		// crash
	RET

TEXT runtime·sigprocmask(SB),NOSPLIT,$0
	RET

TEXT runtime·sigreturn_tramp(SB),NOSPLIT,$-8
	RET

TEXT runtime·sigaction(SB),NOSPLIT,$-8
	RET

TEXT runtime·sigtramp(SB),NOSPLIT,$64
	RET

TEXT runtime·mmap(SB),NOSPLIT,$0
	MOVQ	addr+0(FP), DI		// arg 1 - addr
	MOVQ	n+8(FP), SI		// arg 2 - len
	MOVL	prot+16(FP), DX		// arg 3 - prot
	MOVL	flags+20(FP), CX		// arg 4 - flags
	MOVL	fd+24(FP), R8		// arg 5 - fd
	MOVL	off+28(FP), R9
	SUBQ	$16, SP
	MOVQ	R9, 8(SP)		// arg 7 - offset (passed on stack)
	MOVQ	$0, R9			// arg 6 - pad
	LEAQ	_mmap(SB), AX
	CALL	AX
	ADDQ	$16, SP
	MOVQ	AX, ret+32(FP)
	RET

TEXT runtime·munmap(SB),NOSPLIT,$0
	MOVQ	addr+0(FP), DI		// arg 1 - addr
	MOVQ	n+8(FP), SI		// arg 2 - len
	MOVL	$73, AX			// sys_munmap
	SYSCALL
	JCC	2(PC)
	MOVL	$0xf1, 0xf1		// crash
	RET


// rumprun does not have mad-vice
TEXT runtime·madvise(SB),NOSPLIT,$0
	RET

TEXT runtime·sigaltstack(SB),NOSPLIT,$-8
	RET

// set tls base to DI
// XXXTODO
TEXT runtime·settls(SB),NOSPLIT,$8
	// adjust for ELF: wants to use -8(FS) for g
	ADDQ	$8, DI			// arg 1 - ptr
	MOVQ	$317, AX		// sys__lwp_setprivate
	SYSCALL
	JCC	2(PC)
	MOVL	$0xf1, 0xf1		// crash
	RET

TEXT runtime·sysctl(SB),NOSPLIT,$0
	MOVQ	mib+0(FP), DI		// arg 1 - name
	MOVL	miblen+8(FP), SI		// arg 2 - namelen
	MOVQ	out+16(FP), DX		// arg 3 - oldp
	MOVQ	size+24(FP), CX		// arg 4 - oldlenp
	MOVQ	dst+32(FP), R8		// arg 5 - newp
	MOVQ	ndst+40(FP), R9		// arg 6 - newlen
	LEAQ	_sys___sysctl(SB), AX
	CALL	AX
	JCC 4(PC)
	NEGQ	AX
	MOVL	AX, ret+48(FP)
	RET
	MOVL	$0, AX
	MOVL	AX, ret+48(FP)
	RET

// int32 runtime·kqueue(void)
TEXT runtime·kqueue(SB),NOSPLIT,$0
	MOVQ	$0, DI
	LEAQ	_sys_kqueue(SB), AX
	CALL	AX
	JCC	2(PC)
	NEGQ	AX
	MOVL	AX, ret+0(FP)
	RET

// int32 runtime·kevent(int kq, Kevent *changelist, int nchanges, Kevent *eventlist, int nevents, Timespec *timeout)
TEXT runtime·kevent(SB),NOSPLIT,$0
	MOVL	fd+0(FP), DI
	MOVQ	ev1+8(FP), SI
	MOVL	nev1+16(FP), DX
	MOVQ	ev2+24(FP), CX
	MOVL	nev2+32(FP), R8
	MOVQ	ts+40(FP), R9
	LEAQ	_sys___kevent50(SB), AX
	CALL	AX
	JCC	2(PC)
	NEGQ	AX
	MOVL	AX, ret+48(FP)
	RET

// void runtime·closeonexec(int32 fd)
TEXT runtime·closeonexec(SB),NOSPLIT,$0
	MOVL	fd+0(FP), DI	// fd
	MOVQ	$2, SI		// F_SETFD
	MOVQ	$1, DX		// FD_CLOEXEC
	LEAQ	_sys_fcntl(SB), AX
	CALL	AX
	RET

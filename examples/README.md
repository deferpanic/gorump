Available examples
==================

There are a few examples available currently:

- `hello_world` - simplest possible example, compiling a hello-world app
- `httpd` - a more complex example running a go-builtin HTTP server
- `multiple_go` - demonstrating use of multiple .go files
- `nanomsg` - messaging using nanomsg messaging library

Building Go itself
==================

First of all, you need a Go installed. So get and build that, and then in `go/src` run:

We disable CGO for the build process because of a known incompability with the linker. 

```
CGO_ENABLED=0 GOROOT_BOOTSTRAP=/usr/local/go1.6 GOOS=rumprun GOARCH=amd64 ./make.bash
```

Building applications
=====================

We bundle applications with Rumprun by building a c-archive from them,
and linking that to the Rumprun image.  You will need a Rumprun toolchain
for this step.  We assume you have one and it is in `$PATH`.

You can just run `make`.

Alternatively, to demonstrate the process, below is a depiction of what
actually happens:

```
CC=x86_64-rumprun-netbsd-gcc CGO_ENABLED=1 GOOS=netbsd ../go/bin/go build -buildmode c-archive -v -a -x hello.go
```

(`-vax` is optional, but it's useful to get an idea of what's going on)

You should now have `hello.a`.  To build a Rumprun unikernel image out
of that:

```
x86_64-rumprun-netbsd-gcc -g -o hello hello.c ./hello.a
rumprun-bake hw_virtio hello.bin hello
```

If all went well, you should be able to run it via qemu:

```
system-x86_64 -m 64 -kernel hello.bin
```

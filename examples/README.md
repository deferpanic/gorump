Available examples
==================

There are a few examples available currently:

- `hello_world` - simplest possible example, compiling a hello-world app
- `httpd` - a more complex example running a go-builtin HTTP server
- `multiple_go` - demonstrating use of multiple .go files

Building Go itself
==================

First of all, you need Go 1.4 to bootstrap Go 1.5.  So get and build that,
and then in `go/src` run:

```
GOROOT_BOOTSTRAP=/path/to/go1.4 GOOS=netbsd GOARCH=amd64 ./make.bash
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

If all went well, you should be able to Rumprun the result:

```
rumprun kvm -i hello.bin
```

If it doesn't work
==================

Support for now is pre-alpha, but will hopefully improve in the next few days.

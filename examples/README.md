Building Go itself
==================

First of all, you need Go 1.4 to bootstrap Go 1.5.  So get and build that,
and then in `go/src` run:

```
GOROOT_BOOTSTRAP=/path/to/go1.4 GOOS=netbsd GOARCH=amd64 ./make.bash
```

You'll see some link errors which you should ignore for now, e.g.:

```
runtime.usleep: undefined: _sys___nanosleep50
gorump/go/pkg/tool/linux_amd64/link: too many errors
```

Building applications
=====================

We bundle applications with Rumprun by building a c-archive from them,
and linking that to the Rumprun image.  You will need a Rumprun toolchain
for this step.  We assume you have one.

To build an archive out of the included `main.go` in `examples`:

```
CC=x86_64-rumprun-netbsd-gcc CGO_ENABLED=1 GOOS=netbsd ../go/bin/go build -buildmode c-archive -v -a -x main.go
```

(`-vax` is optional, but it's useful to get an idea of what's going on)

You should now have `main.a`.  To build a Rumprun unikernel image out
of that:

```
x86_64-rumprun-netbsd-gcc -g -o hello hello.c ./main.a
rumprun-bake hw_virtio hello.bin hello
```

If all went well, you should be able to Rumprun the result:

```
rumprun kvm -i -M 2000 hello.bin
```

(yes, you need a lot of memory for now, will fix things to a more
reasonable size later)


If it doesn't work
==================

Support for now is pre-alpha, but will hopefully improve in the next few
days.  Anything beyond hello world is not even expected to work currently.

all: httpd.bin

httpserver.a: httpserver.go
	CC=x86_64-rumprun-netbsd-gcc CGO_ENABLED=1 GOOS=netbsd ../go/bin/go build -buildmode=c-archive -v -a -x httpserver.go

httpserver.h: httpserver.a

httpd: httpserver.a httpserver.h
	RUMPRUN_STUBLINK=succeed x86_64-rumprun-netbsd-gcc -g -o $@ httpd.c httpserver.a

httpd.bin: httpd
	rumprun-bake hw_virtio $@ $<

clean:
	rm -f httpserver.a httpserver.h httpd httpd.bin

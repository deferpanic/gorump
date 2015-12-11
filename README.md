# gorump
go on rumprun

This repo is based on Go the source 1.5.1 stable c7d78ba4df574b5f9a9bb5d17505f40c4d89b81c
downloaded at https://storage.googleapis.com/golang/go1.5.1.src.tar.gz .

On top, the NetBSD platform has been modified to support Rumprun instead.
To generate a patch: `git diff go-1-5-1-upstream master`

See `examples` directory on how to build and use.

### Getting Started

#### Install Go
```
wget https://storage.googleapis.com/golang/go1.5.2.linux-amd64.tar.gz
tar xzf go1.5*
```

#### Build Go
```
CC=x86_64-rumprun-netbsd-gcc CGO_ENABLED=1 GOOS=netbsd /usr/local/go/bin/go build -buildmode=c-archive -v -a -x main.go
```

#### Download Rumprun

```
git clone https://github.com/rumpkernel/rumprun
git pull origin master
git submodule update --init
CC=cc ./build-rr.sh hw
```

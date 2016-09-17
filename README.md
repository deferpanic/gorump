[![Build Status](https://travis-ci.org/deferpanic/gorump.svg?branch=travis)](https://travis-ci.org/deferpanic/gorump)

# gorump

This contains code to run Go on the [Rumprun unikernel](https://github.com/rumpkernel/rumprun).

Rumprun is a special project because it allows you to run your Go apps
unmodified directly on the hypervisor of your choice such as KVM or Xen
as a unikernel.

This allows faster boot times, smaller images and a much smaller attack
surface for security - not to mention it removes every hacker's favorite syscall - fork.

### Quick Start
Want to quickly boot a Go unikernel in 2minutes?

1) [Install virgo - the unikernel runner](github.com/deferpanic/virgo)

2) virgo signup my@email.com mypassword

3) ./virgo pull deferpanic/go

## Slightly Longer Web Start:

1) Sign up for a free account at https://deferpanic.com .

2) Cut/Paste your token in ~/.dprc.

3) Watch the demo video @ https://youtu.be/P8RUrx4jE5A .

4) Fork/Compile/Run a unikernel on deferpanic and then run it locally.

### Overview
We believe unikernels are the future of infrastructure.

This repo contains 2 builds:

1.7beta2: 88840e78905bdff7c8e408385182b4f77e8bdd062cac5c0c6382630588d426c7
https://storage.googleapis.com/golang/go1.7beta2.src.tar.gz

1.5.1: c7d78ba4df574b5f9a9bb5d17505f40c4d89b81c ??
https://storage.googleapis.com/golang/go1.5.1.src.tar.gz 

1.7 still needs a little bit of love in terms of the HTTP support but is booting. 1.5.1 is the 'stable' (hah!) port.

On top, the NetBSD platform has been modified to support Rumprun instead.
To generate a patch: `git diff go-1-5-1-upstream master`.

We don't intend to fork Go but there's quite a lot of work to do to get
it in enough shape to put into the main tree.

Please submit pull requests!

See `examples` directory on how to build and use.

### Getting Started

There are 2 ways you can install - from apt-get or by downloading the
source and the rumprun source and building it yourself.

#### Install from apt-get
```
sudo apt-get install software-properties-common
sudo add-apt-repository ppa:engineering-s/gorump
sudo apt-get update
sudo apt-get install gorump
```

#### Install from source

##### Install dependencies

```
sudo add-apt-repository ppa:ubuntu-toolchain-r/test -y
sudo apt-get update -y
sudo apt-get install qemu-kvm -y
sudo apt-get install g++-4.8 -y
```

or optionally install xen:
```
sudo apt-get install libxen-dev -y
```

##### Install Go to Bootstrap the Modified Go

1.6:

```
wget https://storage.googleapis.com/golang/go1.6.2.linux-amd64.tar.gz
tar xzf go1.6*
sudo mv go /usr/local/go1.6
sudo ln -s /usr/local/go1.6 /usr/local/go
```

##### Add Env variables to your ~/.bashrc
```
export GOROOT=/usr/local/go
export PATH=$PATH:$GOROOT/bin
export GOPATH=/home/$(whoami)/go
export PATH=$PATH:$GOPATH/bin
```

##### Download and Install Rumprun

```
git clone https://github.com/rumpkernel/rumprun
git pull origin master
git submodule update --init
CC=cc ./build-rr.sh hw
```

##### Add the Rumprun env to your path
```
export PATH="${PATH}:/home/$(whoami)/rumprun/rumprun/bin"
```

##### Build the Modified Go
(from within this repository)
```
cd go/src && CGO_ENABLED=0 GOROOT_BOOTSTRAP=/usr/local/go GOOS=rumprun GOARCH=amd64 ./make.bash
```

##### Install the Modified Go
(from within this repository)
```
sudo cp -R ../../go /usr/local/go1.7-patched
sudo rm -rf /usr/local/go
sudo ln -s /usr/local/go1.7-patched /usr/local/go
```

### Create your first Rumprun Hello World Webserver

```
cd examples/httpd && make
```

or 

```
cd examples/httpd && make xen
```

#### Run the Rumprun kernel
##### HW/KVM

Note: If you are not using rumprun to run your image the minimum memory required is north of 32Mb. We suggest 64Mb. If you do use rumprun the default is 64 so nothing to be concerned with.

Check out https://github.com/deferpanic/virgo

##### Hacking Instructions

```
go tool dist list
```

logging options w/qemu:
```
-serial file:/tmp/blah -nographic -vga none
```

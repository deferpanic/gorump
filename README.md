[![Build Status](https://travis-ci.org/deferpanic/gorump.svg?branch=travis)](https://travis-ci.org/deferpanic/gorump)

# gorump

This contains code to run Go on the [Rumprun unikernel](https://github.com/rumpkernel/rumprun).

Rumprun is a special project because it allows you to run your Go apps
unmodified directly on the hypervisor of your choice such as KVM or Xen.

This allows faster boot times, smaller images and a much smaller attack
surface for security.

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

You can find the latest build of the modified Go @ [https://s3.amazonaws.com/dp-gorump/gorump.tar.gz](https://s3.amazonaws.com/dp-gorump/gorump.tar.gz) .

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

- Add Networking to your Image 

via usermode (if you have a wireless only device do this otherwise you have to do the nat hack)

```
system-x86_64 -m 128 -net nic,model=virtio \
	-net user,hostfwd=tcp::3000-:3000 -kernel httpd.bin \
	-append "{ \"net\" : { \"if\":\"vioif0\",,\"type\":\"inet\",,\"method\":\"dhcp\",,},, \"cmdline\": \"http.bin\"}"
```

via tap:
```
sudo ip tuntap add tap0 mode tap
sudo ifconfig tap0 inet 10.181.181.181/24 up
```

- Run Your Hello World Webserver

```
rumprun qemu -i -g '-nographic -vga none' -D 1234 -I t,vioif,'-net tap,ifname=tap0,script=no' -W t,inet,static,10.181.181.180/24 httpd.bin
```

- Test Your Hello World Webserver
```
curl http://10.181.181.180:3000/fast
```

##### XEN

- Get IP of your XEN bridge network interface, by default it's `xenbr0`
```
ifconfig xenbr0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1  }'
```

e.g. output
```
192.168.58.2
```

Choose free IP address from the subnet, in our example we'll take `192.168.58.3` and start Hello World Webserver
```
rumprun xen -i -n inet,static,192.168.58.3/24 httpd-xen.bin
```

- Test Your Hello World Webserver 
```
curl http://192.168.58.3:3000/fast
```

##### Hacking Instructions

```
go tool dist list
```

logging options w/qemu:
```
-serial file:/tmp/blah -nographic -vga none
```

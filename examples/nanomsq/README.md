This is an example on using nanomsg in a Go rumpkernel. It uses nanomsg library, if you built it through [rumprun-packages](https://github.com/rumpkernel/rumprun-packages) and don't have the library in your system path be sure to add appropriate paths for headers and pkg-config:

```shell
C_INCLUDE_PATH=$HOME/rumprun-packages/pkgs/include PKG_CONFIG_PATH=$HOME/rumprun-packages/pkgs/lib/pkgconfig make
```

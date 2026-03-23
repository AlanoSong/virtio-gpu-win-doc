# virtio gpu doc

## 1. architecture

![](./pic/virtio-gpu-win-arch.png)

## 2. projects related

### 2.1 viogpu3d (win kmd part)
- https://github.com/virtio-win/kvm-guest-drivers-windows/pull/943

### 2.2 mesa (win umd part)
- https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/24223

### 2.3 vio-gpu-pci-gl (qemu gpu device)
- qemu: hw/display/virtio-gpu-pci-gl.c

### 2.4 virglrenderer

## 3. build step

### 3.1 build viogpu3d
- under win virt machine
- install visual studio 2022 & win wdk
- open kvm-guest-drivers-windows/viogpu.sln
- build viogpu3d project, then we get viogpu3d.sys
- there is also viogpu3d.inx file under kvm-guest-drivers-windows/viogpu/viogpu3d
- it can be renamed as viogpu3d.inf directly, this is the driver install file for windows system
- its content is just like:
```
...
[SourceDisksFiles]
viogpu3d.sys = 1,,f
viogpu_d3d10.dll = 1,,
viogpu_wgl.dll = 1,,
z.dll = 1,,
...
```
- we could know that we need viogpu3d.sys, viogpu_d3d10.dll, viogpu_wgl.dll, z.dll
- and viogpu_d3d10.dll will be built in mesa project

### 3.2 build mesa
- under win virt machine
- install flex & bison
- install python
- open "Developer Command Prompt for VS 2022"
- run the following cmd:
```cpp
meson .. --prefix=F:\mesa\mesa_prefix  -Dgallium-drivers=virgl -Dgallium-d3d10umd=true -Dgallium-wgl-dll-name=viogpu_wgl -Dgallium-d3d10-dll-name=viogpu_d3d10 -Db_vscrt=mt
```
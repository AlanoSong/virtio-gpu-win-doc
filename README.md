# virtio gpu doc

## 1. architecture

![](./pic/virtio-gpu-win-arch.png)

## 2. projects related

### 2.1 viogpu3d (windows kmd part)
- https://github.com/virtio-win/kvm-guest-drivers-windows/pull/943

### 2.2 mesa (windows umd part)
- https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/24223

### 2.3 vio-gpu-pci-gl (qemu gpu device)
- qemu: hw/display/virtio-gpu-pci-gl.c

### 2.4 virglrenderer

[![Docker Hub](http://dockeri.co/image/dizcza/docker-hashcat)](https://hub.docker.com/r/dizcza/docker-hashcat/)

[![](https://img.shields.io/docker/image-size/dizcza/docker-hashcat/latest?label=latest)](https://hub.docker.com/r/dizcza/docker-hashcat/tags)
[![](https://img.shields.io/docker/image-size/dizcza/docker-hashcat/cuda?label=cuda)](https://hub.docker.com/r/dizcza/docker-hashcat/tags)
[![](https://img.shields.io/docker/image-size/dizcza/docker-hashcat/intel-cpu?label=intel-cpu)](https://hub.docker.com/r/dizcza/docker-hashcat/tags)
[![](https://img.shields.io/docker/image-size/dizcza/docker-hashcat/intel-gpu?label=intel-gpu)](https://hub.docker.com/r/dizcza/docker-hashcat/tags)
[![](https://img.shields.io/docker/image-size/dizcza/docker-hashcat/pocl?label=pocl)](https://hub.docker.com/r/dizcza/docker-hashcat/tags)


[Hashcat](https://hashcat.net/hashcat/) with hashcat utils on Ubuntu 18.04 for Nvidia GPUs (`:cuda`), AMD GPUs (`:latest`), Intel GPUs (`:intel-gpu`), Intel CPUs (`:intel-cpu`), KVMs and AMD CPUs (`:pocl`).

```
docker pull dizcza/docker-hashcat

docker run --gpus all -it dizcza/docker-hashcat /bin/bash
```

Then inside the docker container run

```
# list the available CUDA and OpenCL interfaces
hashcat -I

# run a bechmark
hashcat -b
```

## Tags

### latest

`docker pull dizcza/docker-hashcat:latest`

The `:latest` is a generic tag for both Nvidia and AMD GPUs. It includes CUDA and the (default) OpenCL backends. Hashcat will pick CUDA, if your hardware supports it, because CUDA is faster than OpenCL (see [thread](https://hashcat.net/forum/thread-9303.html)). If your compute device does not support CUDA, hashcat will fall back to the OpenCL backend.

### cuda

`docker pull dizcza/docker-hashcat:cuda`

Recommended for Nvidia GPUs. If you have any issues running this container with Nvidia GPU, please drop a comment in this [issue](https://github.com/dizcza/docker-hashcat/issues/6).


### intel-cpu

`docker pull dizcza/docker-hashcat:intel-cpu`

Suitable for Intel CPUs.


### intel-gpu

`docker run -it --device /dev/dri:/dev/dri dizcza/docker-hashcat:intel-gpu`

Intel NEO OpenCL driver (suitable for the majority of laptops with an embedded Intel graphics card). 

### pocl

`docker pull dizcza/docker-hashcat:pocl`

An alternative to `:intel-cpu` tag, the `:pocl` tag provides an open-source (but not officially supported by HashCat) implementation of OpenCL, which you can find in the `pocl-opencl-icd` linux package (usually, outdated). Suitable for Intel & AMD CPUs and KVMs. For more information about using POCL in hashcat refer to the [discussion](https://github.com/hashcat/hashcat/issues/2398#issuecomment-628732757).

Try `:pocl` tag if no other tag worked for you.

## Deprecated tags

### intel-cpu-legacy

`docker pull dizcza/docker-hashcat:intel-cpu-legacy`

The `:intel-cpu-legacy` tag keeps the latest successful build of Hashcat 6.2.6 + deprecated IntelCPU runtime file. Now it's superseded by the `:intel-cpu` tag, which contains up-to-date Intel OpenCL CPU drivers.


## Benchmark

Benchmark command: `hashcat -m2500 -b`

| Tag(s) | Device | Speed, H/s |
|---|----------|-----------|
|latest, cuda| GeForce GTX 1080 Ti | 603500 |
|intel-gpu| Intel UHD Graphics 620 | 8240 |
|intel-cpu| Intel(R) Core(TM) i7-8550U CPU @ 1.80GHz | 11009 |
|pocl| pthread-Intel(R) Core(TM) i7-8550U CPU @ 1.80GHz | 7647 |

If you have a laptop with an embedded Intel GPU card, you can combine `intel-cpu` and `intel-gpu` installations manually to utilize both CPU and GPU, increasing the speed up to 15000 H/s.

## Hashcat utils

Along with the hashcat, the following utility packages are installed:

* [hashcat-utils](https://github.com/hashcat/hashcat-utils) for converting raw Airodump to HCCAPX capture format; info `cap2hccapx -h`
* [hcxtools](https://github.com/zerbea/hcxtools) for inspecting, filtering, and converting capture files;
* [hcxdumptool](https://github.com/ZerBea/hcxdumptool) for capturing packets from wlan devices in any format you might think of; info `hcxdumptool -h`
* [kwprocessor](https://github.com/hashcat/kwprocessor) for creating advanced keyboard-walk password candidates; info `kwp -h`


## FAQ

* Warning "Device #1: Unstable OpenCL driver detected!" can be suppressed by adding the `--force` flag to a hashcat command (f.i., `hashcat -m2500 -b --force`).


## Usages

This Dockerfile is used in the [hashcat-wpa-server](https://github.com/dizcza/hashcat-wpa-server) project to automate WPA/WPA2 hashes cracking.

To build upon this Dockerfile with your custom packages, create a new Dockerfile that starts with

```Dockerfile
ARG branch=latest
FROM dizcza/docker-hashcat:$branch
```

The `branch` arg can be any tag listed above.


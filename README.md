[![Docker Hub](http://dockeri.co/image/dizcza/docker-hashcat)](https://hub.docker.com/r/dizcza/docker-hashcat/)

[![](https://images.microbadger.com/badges/version/dizcza/docker-hashcat.svg)](https://microbadger.com/images/dizcza/docker-hashcat "Nvidia GPU")
[![](https://images.microbadger.com/badges/image/dizcza/docker-hashcat.svg)](https://microbadger.com/images/dizcza/docker-hashcat "Nvidia GPU")

[![](https://images.microbadger.com/badges/version/dizcza/docker-hashcat:intel-cpu.svg)](https://microbadger.com/images/dizcza/docker-hashcat:intel-cpu "Intel CPU")
[![](https://images.microbadger.com/badges/image/dizcza/docker-hashcat:intel-cpu.svg)](https://microbadger.com/images/dizcza/docker-hashcat:intel-cpu "Intel CPU")

[![](https://images.microbadger.com/badges/version/dizcza/docker-hashcat:pocl.svg)](https://microbadger.com/images/dizcza/docker-hashcat:pocl "POCL")
[![](https://images.microbadger.com/badges/image/dizcza/docker-hashcat:pocl.svg)](https://microbadger.com/images/dizcza/docker-hashcat:pocl "POCL")


[Hashcat](https://hashcat.net/hashcat/) with hashcat utils on Ubuntu 18.04 OpenCL for Nvidia GPUs (`:latest`) and Intel CPU (`:intel-cpu`).

```
docker pull dizcza/docker-hashcat
nvidia-docker run -it dizcza/docker-hashcat /bin/bash

# run hashcat bechmark inside the docker container
hashcat -b
```

## Tags

### latest

`docker pull dizcza/docker-hashcat:latest`

The `:latest` tag is for GPUs. It includes both CUDA and OpenCL backends. Hashcat will pick CUDA, if your hardware supports it, because CUDA is faster than OpenCL (see [thread](https://hashcat.net/forum/thread-9303.html)). If your compute device does not support CUDA, hashcat will fall back to OpenCL backend.


### cuda

`docker pull dizcza/docker-hashcat:cuda`

Recommended for Nvidia GPUs.


### intel-cpu

`docker pull dizcza/docker-hashcat:intel-cpu`

For those who don't have GPUs, use `:intel-cpu` tag (suitable for AWS free tier instances):


### pocl

`docker pull dizcza/docker-hashcat:pocl`

An alternative to `:intel-cpu` tag, the `:pocl` tag provides open-source (but not officially supported by HashCat) implementation of OpenCL, which you can find in `pocl-opencl-icd` linux package (usually, outdated). For more information about using POCL in hashcat refer to the [discussion](https://github.com/hashcat/hashcat/issues/2398#issuecomment-628732757).

Try `:pocl` tag if `:intel-cpu` does not work for you.


## Deprecated tags

### nvidia-full

`:nvidia-full` is an old build of the `:latest` tag. This tag is deprecated.


## Hashcat utils

Along with the hashcat, the following utility packages are installed:

* [hashcat-utils](https://github.com/hashcat/hashcat-utils) for converting raw Airodump to HCCAPX capture format; info `cap2hccapx -h`
* [hcxtools](https://github.com/zerbea/hcxtools) for inspecting, filtering, and converting capture files;
* [hcxdumptool](https://github.com/ZerBea/hcxdumptool) for capturing packets from wlan devices in any format you might think of; info `hcxdumptool -h`
* [kwprocessor](https://github.com/hashcat/kwprocessor) for creating advanced keyboard-walk password candidates; info `kwp -h`


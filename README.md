[![Docker Hub](http://dockeri.co/image/dizcza/docker-hashcat)](https://hub.docker.com/r/dizcza/docker-hashcat/)

[![](https://images.microbadger.com/badges/version/dizcza/docker-hashcat.svg)](https://microbadger.com/images/dizcza/docker-hashcat "Get your own version badge on microbadger.com")
[![](https://images.microbadger.com/badges/image/dizcza/docker-hashcat.svg)](https://microbadger.com/images/dizcza/docker-hashcat "Get your own image badge on microbadger.com")

[![](https://images.microbadger.com/badges/version/dizcza/docker-hashcat:intel-cpu.svg)](https://microbadger.com/images/dizcza/docker-hashcat:intel-cpu "Get your own version badge on microbadger.com")
[![](https://images.microbadger.com/badges/image/dizcza/docker-hashcat:intel-cpu.svg)](https://microbadger.com/images/dizcza/docker-hashcat:intel-cpu "Get your own image badge on microbadger.com")


[Hashcat](https://hashcat.net/hashcat/) with hashcat utils on Ubuntu 18.04 OpenCL for Nvidia GPUs (`:latest`) and Intel CPU (`:intel-cpu`).

```
docker pull dizcza/docker-hashcat
nvidia-docker run -it dizcza/docker-hashcat /bin/bash

# run hashcat bechmark inside the docker container
hashcat -b
```

## Nvidia GPU

 `docker pull dizcza/docker-hashcat:latest`


## Intel CPU

For those who don't have GPUs, use `:intel-cpu` tag (suitable for AWS free tier instances):

 `docker pull dizcza/docker-hashcat:intel-cpu`

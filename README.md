[Hashcat](https://hashcat.net/hashcat/) with [Hashcat-utils](https://github.com/hashcat/hashcat-utils/) on Ubuntu 16.04 OpenCL 1.2 for Nvidia GPUs (tags `:latest`, `:nvidia-full`) and Intel CPU (`:intel-cpu`).

Docker hub: https://hub.docker.com/r/dizcza/docker-hashcat/

"_Why OpenCL 1.2 and not 2.0?_" and "_Does hashcat not actually use CUDA for Nvidia cards?_" see [here](https://hashcat.net/forum/thread-6712-post-35830.html).

```
docker pull dizcza/docker-hashcat
nvidia-docker run -it dizcza/docker-hashcat /bin/bash

# run hashcat bechmark inside the docker container
hashcat -b
```

## Nvidia GPU

If you've installed and configured nvidia-opencl driver on your host machine, use `:latest` tag (~220 Mb). 
Otherwise, use standalone tag `:nvidia-full` (~1.62 Gb):
 
 `docker pull dizcza/docker-hashcat:nvidia-full`


## Intel CPU

For those who don't have GPUs, use `:intel-cpu` tag (suitable for AWS free tier instances):

 `docker pull dizcza/docker-hashcat:intel-cpu`

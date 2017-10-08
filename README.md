[Hashcat](https://hashcat.net/hashcat/) with [Hashcat-utils](https://github.com/hashcat/hashcat-utils/) for Ubuntu 16.04 CUDA 8.0 (`:nvidia-full`) and Intel CPU (`:intel-cpu`)

```
docker pull dizcza/docker-hashcat
nvidia-docker run -it dizcza/docker-hashcat /bin/bash

# run hashcat bechmark inside the docker container
hashcat -b
```

## Nvidia GPU

If you've installed and configured nvidia-opencl driver on your host machine, use `:latest` tag (~880 Mb). 
Otherwise, use standalone tag `:nvidia-full` (~2.2 Gb):
 
 `docker pull dizcza/docker-hashcat:nvidia-full`

You may see some [warnings](https://github.com/hashcat/hashcat/issues/1360). Ignore them.


# Intel CPU

For those who don't have GPUs, use `:intel-cpu` tag (suitable for AWS free tier instances):

 `docker pull dizcza/docker-hashcat:intel-cpu`

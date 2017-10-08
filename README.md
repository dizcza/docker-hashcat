[Hashcat](https://hashcat.net/hashcat/) with [Hashcat-utils](https://github.com/hashcat/hashcat-utils/) for Ubuntu 16.04 CUDA 8.0. It's a lightweight version (~880 Mb), comparing to https://github.com/cryptolovi/hashcat-docker (~2.2 Gb), yet with the same functional. The trick is that you don't need to install `nvidia-current` package if your host machine already has one.

```
docker pull dizcza/docker-hashcat
nvidia-docker run -it dizcza/docker-hashcat /bin/bash

# run hashcat bechmark inside the docker container
hashcat -b
```

If your nvidia driver is less than 367.x, you'll see [warnings](https://github.com/hashcat/hashcat/issues/1360). Ignore them.

FROM nvidia/cuda:8.0-runtime-ubuntu16.04

######################### Ubuntu 14.04 OpenCL Dockerfile ###########################
LABEL com.nvidia.volumes.needed="nvidia_driver"

RUN apt-get update && apt-get install -y --no-install-recommends \
        ocl-icd-libopencl1 \
        clinfo && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/OpenCL/vendors && \
    echo "libnvidia-opencl.so.1" > /etc/OpenCL/vendors/nvidia.icd

RUN echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf && \
    echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf

ENV PATH /usr/local/nvidia/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64:${LD_LIBRARY_PATH}
####################################################################################

ENV HASHCAT_VERSION        hashcat-3.6.0
ENV HASHCAT_UTILS_VERSION  1.8

# Update & install packages for installing hashcat
RUN apt-get update && \
    apt-get install -y wget p7zip

RUN mkdir /hashcat

#Install and configure hashcat
RUN cd /hashcat && \
    wget https://hashcat.net/files/${HASHCAT_VERSION}.7z && \
    7zr x ${HASHCAT_VERSION}.7z && \
    rm ${HASHCAT_VERSION}.7z

RUN cd /hashcat && \
    wget https://github.com/hashcat/hashcat-utils/releases/download/v${HASHCAT_UTILS_VERSION}/hashcat-utils-${HASHCAT_UTILS_VERSION}.7z && \
    7zr x hashcat-utils-${HASHCAT_UTILS_VERSION}.7z && \
    rm hashcat-utils-${HASHCAT_UTILS_VERSION}.7z

#Add link for binary
RUN ln -s /hashcat/${HASHCAT_VERSION}/hashcat64.bin /usr/bin/hashcat
RUN ln -s /hashcat/hashcat-utils-${HASHCAT_UTILS_VERSION}/bin/cap2hccapx.bin /usr/bin/cap2hccapx

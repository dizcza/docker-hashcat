FROM ubuntu:18.04

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

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility
################################ end nvidia opencl driver ################################

ENV HASHCAT_VERSION        hashcat-5.1.0
ENV HASHCAT_UTILS_VERSION  1.9
ENV HCXTOOLS_VERSION       5.1.4
ENV HCXDUMPTOOL_VERSION    5.1.4

# Update & install packages for installing hashcat
RUN apt-get update && \
    apt-get install -y wget p7zip make build-essential git libcurl4-openssl-dev libssl-dev zlib1g-dev

RUN mkdir /hashcat

WORKDIR /hashcat
RUN wget --no-check-certificate https://hashcat.net/files/${HASHCAT_VERSION}.7z && \
    7zr x ${HASHCAT_VERSION}.7z && \
    rm ${HASHCAT_VERSION}.7z

RUN wget --no-check-certificate https://github.com/hashcat/hashcat-utils/releases/download/v${HASHCAT_UTILS_VERSION}/hashcat-utils-${HASHCAT_UTILS_VERSION}.7z && \
    7zr x hashcat-utils-${HASHCAT_UTILS_VERSION}.7z && \
    rm hashcat-utils-${HASHCAT_UTILS_VERSION}.7z

WORKDIR /hashcat
RUN wget --no-check-certificate https://github.com/ZerBea/hcxtools/archive/${HCXTOOLS_VERSION}.tar.gz && \
    tar xfz ${HCXTOOLS_VERSION}.tar.gz && \
    rm ${HCXTOOLS_VERSION}.tar.gz
WORKDIR hcxtools-${HCXTOOLS_VERSION}
RUN make install

WORKDIR /hashcat
RUN wget --no-check-certificate https://github.com/ZerBea/hcxdumptool/archive/${HCXDUMPTOOL_VERSION}.tar.gz && \
    tar xfz ${HCXDUMPTOOL_VERSION}.tar.gz && \
    rm ${HCXDUMPTOOL_VERSION}.tar.gz
WORKDIR hcxdumptool-${HCXDUMPTOOL_VERSION}
RUN make install

WORKDIR /hashcat
# commit 49059f3 on Jun 19, 2018
RUN git clone https://github.com/hashcat/kwprocessor.git
WORKDIR kwprocessor
RUN make
WORKDIR /hashcat

#Add link for binary
RUN ln -s /hashcat/${HASHCAT_VERSION}/hashcat64.bin /usr/bin/hashcat
RUN ln -s /hashcat/hashcat-utils-${HASHCAT_UTILS_VERSION}/bin/cap2hccapx.bin /usr/bin/cap2hccapx
RUN ln -s /hashcat/kwprocessor/kwp /usr/bin/kwp

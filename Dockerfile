FROM ubuntu:18.04

LABEL maintainer="Danylo Ulianych"

RUN apt-get update && \
    apt-get install -y git clang-9 libclang-9-dev build-essential ocl-icd-libopencl1 cmake git pkg-config make ninja-build ocl-icd-libopencl1 ocl-icd-dev ocl-icd-opencl-dev libhwloc-dev zlib1g zlib1g-dev clinfo dialog apt-utils

ENV POCL_VERSION           v1.7

WORKDIR /root

RUN mkdir -p /etc/OpenCL/vendors/
RUN git clone https://github.com/pocl/pocl.git && cd pocl && git checkout ${POCL_VERSION} && \
    mkdir build && cd build && cmake .. && make install -j4 && cp pocl.icd /etc/OpenCL/vendors/

##################### end POCL driver installation #####################

ENV HASHCAT_VERSION        v6.2.2
ENV HASHCAT_UTILS_VERSION  v1.9
ENV HCXTOOLS_VERSION       6.1.5
ENV HCXDUMPTOOL_VERSION    6.1.6
ENV HCXKEYS_VERSION        master

# Update & install packages for installing hashcat
RUN apt-get update && \
    apt-get install -y wget make clinfo build-essential git libcurl4-openssl-dev libssl-dev zlib1g-dev libcurl4-openssl-dev libssl-dev

WORKDIR /root

RUN git clone https://github.com/hashcat/hashcat.git && cd hashcat && git checkout ${HASHCAT_VERSION} && make install -j4

RUN git clone https://github.com/hashcat/hashcat-utils.git && cd hashcat-utils/src && git checkout ${HASHCAT_UTILS_VERSION} && make
RUN ln -s /root/hashcat-utils/src/cap2hccapx.bin /usr/bin/cap2hccapx

RUN git clone https://github.com/ZerBea/hcxtools.git && cd hcxtools && git checkout ${HCXTOOLS_VERSION} && make install

RUN git clone https://github.com/ZerBea/hcxdumptool.git && cd hcxdumptool && git checkout ${HCXDUMPTOOL_VERSION} && make install

RUN git clone https://github.com/hashcat/kwprocessor.git && cd kwprocessor && git checkout ${HCXKEYS_VERSION} && make
RUN ln -s /root/kwprocessor/kwp /usr/bin/kwp

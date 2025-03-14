FROM ubuntu:22.04

# Set noninteractive mode to avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

LABEL maintainer="Danylo Ulianych"

RUN apt-get update && \
    apt install -y wget software-properties-common

# Add LLVM repository key and APT source
RUN wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | tee /etc/apt/trusted.gpg.d/llvm.asc \
    && echo "deb http://apt.llvm.org/jammy/ llvm-toolchain-jammy-18 main" | tee /etc/apt/sources.list.d/llvm.list


ENV LLVM_VERSION           18
ENV POCL_VERSION           v6.0
ENV PATH                   "$PATH:/usr/lib/llvm-${LLVM_VERSION}/bin/"

RUN apt-get update && \
    apt-get install -y python3-dev libpython3-dev build-essential ocl-icd-libopencl1 cmake git pkg-config libclang-${LLVM_VERSION}-dev clang-${LLVM_VERSION} llvm-${LLVM_VERSION} make ninja-build ocl-icd-libopencl1 ocl-icd-dev ocl-icd-opencl-dev libhwloc-dev zlib1g zlib1g-dev clinfo dialog apt-utils libxml2-dev libclang-cpp${LLVM_VERSION}-dev libclang-cpp${LLVM_VERSION} llvm-${LLVM_VERSION}-dev libpcap-dev

WORKDIR /root

RUN mkdir -p /etc/OpenCL/vendors/
RUN git clone https://github.com/pocl/pocl.git && cd pocl && git checkout ${POCL_VERSION} && \
    mkdir build && cd build && cmake .. && make install -j4 && cp pocl.icd /etc/OpenCL/vendors/

##################### end POCL driver installation #####################

ENV HASHCAT_VERSION        master
ENV HASHCAT_UTILS_VERSION  v1.9
ENV HCXTOOLS_VERSION       6.3.5
ENV HCXDUMPTOOL_VERSION    6.3.5
ENV HCXKEYS_VERSION        master

# Update & install packages for installing hashcat
RUN apt-get update && \
    apt-get install -y wget make clinfo build-essential git libcurl4-openssl-dev libssl-dev zlib1g-dev libcurl4-openssl-dev libssl-dev pciutils

# Fetch PCI IDs list to display proper GPU names
RUN update-pciids

WORKDIR /root

RUN git clone https://github.com/hashcat/hashcat.git && cd hashcat && git checkout ${HASHCAT_VERSION} && make install -j4

RUN git clone https://github.com/hashcat/hashcat-utils.git && cd hashcat-utils/src && git checkout ${HASHCAT_UTILS_VERSION} && make
RUN ln -s /root/hashcat-utils/src/cap2hccapx.bin /usr/bin/cap2hccapx

RUN git clone https://github.com/ZerBea/hcxtools.git && cd hcxtools && git checkout ${HCXTOOLS_VERSION} && make install

RUN git clone https://github.com/ZerBea/hcxdumptool.git && cd hcxdumptool && git checkout ${HCXDUMPTOOL_VERSION} && make install

RUN git clone https://github.com/hashcat/kwprocessor.git && cd kwprocessor && git checkout ${HCXKEYS_VERSION} && make
RUN ln -s /root/kwprocessor/kwp /usr/bin/kwp

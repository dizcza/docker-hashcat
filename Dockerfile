FROM ubuntu:22.04

RUN apt-get update && apt-get install -y clinfo wget

RUN wget https://github.com/intel/intel-graphics-compiler/releases/download/igc-1.0.12812.24/intel-igc-core_1.0.12812.24_amd64.deb
RUN wget https://github.com/intel/intel-graphics-compiler/releases/download/igc-1.0.12812.24/intel-igc-opencl_1.0.12812.24_amd64.deb
RUN wget https://github.com/intel/compute-runtime/releases/download/22.49.25018.24/intel-level-zero-gpu-dbgsym_1.3.25018.24_amd64.ddeb
RUN wget https://github.com/intel/compute-runtime/releases/download/22.49.25018.24/intel-level-zero-gpu_1.3.25018.24_amd64.deb
RUN wget https://github.com/intel/compute-runtime/releases/download/22.49.25018.24/intel-opencl-icd-dbgsym_22.49.25018.24_amd64.ddeb
RUN wget https://github.com/intel/compute-runtime/releases/download/22.49.25018.24/intel-opencl-icd_22.49.25018.24_amd64.deb
RUN wget https://github.com/intel/compute-runtime/releases/download/22.49.25018.24/libigdgmm12_22.3.0_amd64.deb
RUN dpkg -i *.deb && rm *.deb

LABEL maintainer="Danylo Ulianych"


ENV HASHCAT_VERSION        v6.2.6
ENV HASHCAT_UTILS_VERSION  v1.9
ENV HCXTOOLS_VERSION       6.2.7
ENV HCXDUMPTOOL_VERSION    6.2.7
ENV HCXKEYS_VERSION        master

# Update & install packages for installing hashcat
RUN apt-get update && \
    apt-get install -y wget make clinfo build-essential git libcurl4-openssl-dev libssl-dev zlib1g-dev libcurl4-openssl-dev libssl-dev pkg-config pciutils
RUN apt-get autoremove -y && rm -rf /var/lib/apt/lists/*

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

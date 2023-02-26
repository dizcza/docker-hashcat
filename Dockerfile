FROM intel/oneapi-basekit:devel-ubuntu22.04

LABEL maintainer="Danylo Ulianych"

# Fix apt update forbidden issue
RUN rm /etc/apt/sources.list.d/intel-graphics.list

# Remove FPGA device support
RUN rm /opt/intel/oneapi/compiler/2023.0.0/linux/lib/x64/cl.fpga_emu.cfg
RUN rm -rf /opt/intel/oneapi/compiler/2023.0.0/linux/lib/oclfpga
RUN rm /etc/OpenCL/vendors/Altera.icd
RUN rm /etc/OpenCL/vendors/Intel_FPGA_SSG_Emulator.icd


RUN apt-get update && apt-get install -y clinfo pkg-config

ENV HASHCAT_VERSION        v6.2.6
ENV HASHCAT_UTILS_VERSION  v1.9
ENV HCXTOOLS_VERSION       6.2.7
ENV HCXDUMPTOOL_VERSION    6.2.7
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

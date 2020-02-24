FROM ubuntu:18.04

LABEL maintainer="Danylo Ulianych"

RUN apt-get update && apt-get install -y alien clinfo

# Install Intel OpenCL driver
#ENV INTEL_OPENCL_URL=http://registrationcenter-download.intel.com/akdlm/irc_nas/vcp/13793/l_opencl_p_18.1.0.013.tgz
ENV INTEL_OPENCL_URL=http://registrationcenter-download.intel.com/akdlm/irc_nas/9019/opencl_runtime_16.1.1_x64_ubuntu_6.4.0.25.tgz

RUN mkdir -p /tmp/opencl-driver-intel
WORKDIR /tmp/opencl-driver-intel
RUN curl -O $INTEL_OPENCL_URL; \
    tar -xzf $(basename $INTEL_OPENCL_URL); \
    for i in $(basename $INTEL_OPENCL_URL .tgz)/rpm/*.rpm; do alien --to-deb $i; done; \
    dpkg -i *.deb; \
    mkdir -p /etc/OpenCL/vendors; \
    echo /opt/intel/*/lib64/libintelocl.so > /etc/OpenCL/vendors/intel.icd; \
    rm -rf *

ENV HASHCAT_VERSION        hashcat-5.1.0
ENV HASHCAT_UTILS_VERSION  1.9
ENV HCXTOOLS_VERSION       5.3.0
ENV HCXDUMPTOOL_VERSION    6.0.1

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

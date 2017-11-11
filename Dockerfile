FROM cwpearson/opencl2.0-intel-cpu

ENV HASHCAT_VERSION        hashcat-3.6.0
ENV HASHCAT_UTILS_VERSION  1.8

# Update & install packages for installing hashcat
RUN apt-get update && \
    apt-get install -y wget p7zip

RUN mkdir /hashcat

#Install and configure hashcat: it's either the latest release or in legacy files
RUN cd /hashcat && \
    wget --no-check-certificate https://hashcat.net/files_legacy/${HASHCAT_VERSION}.7z && \
    wget --no-check-certificate https://hashcat.net/files/${HASHCAT_VERSION}.7z && \
    7zr x ${HASHCAT_VERSION}.7z && \
    rm ${HASHCAT_VERSION}.7z

RUN cd /hashcat && \
    wget --no-check-certificate https://github.com/hashcat/hashcat-utils/releases/download/v${HASHCAT_UTILS_VERSION}/hashcat-utils-${HASHCAT_UTILS_VERSION}.7z && \
    7zr x hashcat-utils-${HASHCAT_UTILS_VERSION}.7z && \
    rm hashcat-utils-${HASHCAT_UTILS_VERSION}.7z

#Add link for binary
RUN ln -s /hashcat/${HASHCAT_VERSION}/hashcat64.bin /usr/bin/hashcat
RUN ln -s /hashcat/hashcat-utils-${HASHCAT_UTILS_VERSION}/bin/cap2hccapx.bin /usr/bin/cap2hccapx

FROM resin/rpi-raspbian:jessie

MAINTAINER NTT-TNN <nguyentienthao@gmail.com>

## Variable ENV
ENV CAMEL_VERSION=${CAMEL_VERSION:-2.16.1}
ENV RHIOT_VERSION=${RHIOT_VERSION:-0.1.3}
ENV JAVA_VERSION=${JAVA_VERSION:-7}
ENV KURA_VERSION=${KURA_VERSION:-2.1.0}
ENV RPI_VERSION=${RPI_VERSION:-raspberry-pi-bplus-nn}

ENV JAVA_HOME=/usr/lib/jvm/java-${JAVA_VERSION}-openjdk-armhf
ENV KURA_HOME=/opt/eclipse/kura
ENV RHIOT_HOME=/opt/rhiot
ENV RHIOT_EMBEDDED_PLUGINS_FOLDER=${RHIOT_HOME}/plugins-embedded
ENV RHIOT_BIN_FOLDER=${RHIOT_HOME}/bin

RUN apt-get update
RUN apt-get dist-upgrade -y
RUN DEBIAN_FRONTEND=noninteractive apt-get -y dist-upgrade
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install python-software-properties
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install software-properties-common
# RUN add-apt-repository ppa:openjdk-r/ppa 
RUN apt-get update   
RUN apt-get install -y openjdk-8-jre-headless
# RUN add-apt-repository "deb http://archive.ubuntu.com/ubuntu $(lsb_release -sc) main"
## Debian/Raspbian package installation
RUN apt-get update && \
    apt-get install -y apt-utils unzip ethtool dos2unix telnet bind9 hostapd isc-dhcp-server iw monit wget openjdk-7-jdk --no-install-recommends  && \
    rm -rf /var/lib/apt/lists/*
RUN apt-get install -y bluez-hcidump
RUN wget http://download.eclipse.org/kura/releases/3.1.0/kura_3.1.0_raspberry-pi-2-3_installer.deb
# RUN apt-get install gdebi-core
# RUN apt-get purge dhcpcd5
# RUN apt-get remove network-manager
RUN apt-get update
RUN apt install -y wireless-tools
RUN dpkg -i kura_3.1.0_raspberry-pi-2-3_installer.deb

# ## Kura installation
# RUN wget http://download.eclipse.org/kura/releases/${KURA_VERSION}/kura_${KURA_VERSION}_raspberry-pi-2-3_installer.deb
# RUN sudo dpkg -i kura_${KURA_VERSION}_raspberry-pi-2-3_installer.deb
# RUN rm kura_${KURA_VERSION}_raspberry-pi-2-3_installer.deb

## Hack for debian/jessie
RUN if [ -d $(dirname `find /lib -name libudev.so.1`) ] && [ ! -f $(dirname `find /lib -name libudev.so.1`)/libudev.so.0 ] ; then ln -sf `find /lib -name libudev.so.1` $(dirname `find /lib -name libudev.so.1`)/libudev.so.0; fi

## Web and telnet
EXPOSE 80
EXPOSE 5002
EXPOSE 1450


## Main start
CMD /opt/eclipse/kura/bin/start_kura.sh


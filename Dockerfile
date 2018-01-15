#
# Licensed to the Rhiot under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

FROM resin/rpi-raspbian:latest

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


## Debian/Raspbian package installation
RUN apt-get update && \
    apt-get install -y apt-utils unzip ethtool dos2unix telnet bind9 hostapd isc-dhcp-server iw monit wget openjdk-7-jdk --no-install-recommends  && \
    rm -rf /var/lib/apt/lists/*
    
RUN wget http://download.eclipse.org/kura/releases/2.1.0/kura_2.1.0_raspberry-pi-2-3_installer.deb
RUN apt-get install gdebi-core
RUN  dpkg -i kura_2.1.0_raspberry-pi-2-3_installer.deb

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
CMD service kura start && while true


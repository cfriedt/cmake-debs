FROM ubuntu:bionic

ENV PN cmake
ENV PV 3.15.2
ENV PR 1
ENV BIN_PN cmake
ENV BIN_PACKAGE ${BIN_PN}_${PV}-${PR}
ENV PREFIX usr/local
ENV GH_USER Christopher Friedt
ENV GH_EMAIL "chrisfriedt@gmail.com"
ENV GH_URL https://github.com/Kitware/CMake

#RUN apt-get update && apt install -y build-essential git autoconf automake libtool pkg-config libboost-all-dev bison flex curl libglib2.0-dev libssl-dev dh-make bzr-builddeb libevent-dev
RUN apt-get update && apt install -y build-essential git curl libssl-dev dh-make bzr-builddeb

RUN curl -L -o ${PN}-${PV}.tar.gz "${GH_URL}/releases/download/v${PV}/${PN}-${PV}.tar.gz"
RUN tar xpvzf ${PN}-${PV}.tar.gz
WORKDIR ${PN}-${PV}
RUN ./bootstrap --parallel=`nproc --all`
RUN make -j`nproc --all`
RUN make -j`nproc --all` install

# How to make a 'basic' .deb
# See https://ubuntuforums.org/showthread.php?t=910717

WORKDIR ../${PN}-${PV}
RUN make -j`nproc --all` DESTDIR=`pwd`/../${BIN_PACKAGE} install
WORKDIR ../
COPY mkdeb.sh .
RUN sh mkdeb.sh ${BIN_PACKAGE} ${BIN_PN} ${PV} ${PR} "${GH_USER}" ${GH_EMAIL}
RUN mv ${BIN_PACKAGE}.deb ${BIN_PN}_${PV}-${PR}.`dpkg --print-architecture`.deb

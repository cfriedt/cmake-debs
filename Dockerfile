FROM ubuntu:xenial

ENV PN cmake
ENV PV 3.15.2
ENV PR 1
ENV BIN_PN cmake
ENV BIN_PACKAGE ${BIN_PN}_${PV}-${PR}
ENV PREFIX usr/local

RUN apt-get update && apt install -y build-essential git autoconf automake libtool pkg-config libboost-all-dev bison flex curl libglib2.0-dev libssl-dev dh-make bzr-builddeb libevent-dev

RUN curl -L -o ${PN}-${PV}.tar.gz "https://github.com/Kitware/CMake/releases/download/v${PV}/${PN}-${PV}.tar.gz"
RUN tar xpvzf ${PN}-${PV}.tar.gz
WORKDIR ${PN}-${PV}
RUN ./bootstrap --parallel=`nproc --all`
RUN make -j`nproc --all`
RUN make -j`nproc --all` install

# How to make a 'basic' .deb
# See https://ubuntuforums.org/showthread.php?t=910717

WORKDIR ../${PN}-${PV}
RUN make -j`nproc --all` DESTDIR=`pwd`/../${BIN_PACKAGE} install
WORKDIR ../${BIN_PACKAGE}
RUN mkdir -p DEBIAN
RUN echo "Package: ${BIN_PN}" > DEBIAN/control
RUN echo "Version: ${PV}-${PR}" >> DEBIAN/control
RUN echo "Section: base" >> DEBIAN/control
RUN echo "Priority: optional" >> DEBIAN/control
RUN echo "Architecture: `dpkg --print-architecture`" >> DEBIAN/control
#RUN echo "Depends: " >> DEBIAN/control
RUN echo "Maintainer: Christopher Friedt <chrisfriedt@gmail.com>" >> DEBIAN/control
RUN echo "Description: CMake" >> DEBIAN/control
RUN echo " CMake" >> DEBIAN/control
WORKDIR ..
RUN dpkg-deb --build ${BIN_PACKAGE}

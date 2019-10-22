FROM  debian:latest
LABEL version="0.0.2" \
      maintainer="kedokudo <chenzhang8722@gmail.com>" \
      lastupdate="2019-10-22"
USER  root


# Install necessary libraries from offical repo
RUN apt-get  update  -y   && \
    apt-get  upgrade -y   && \
    apt-get  install -y      \
        apt-utils            \
        build-essential      \
        libreadline-dev      \
        wget                 \
        &&                   \
    rm -rf /var/lib/apt/lists/*


# Get the latest version of EPICS
ENV APP_ROOT="/opt"
ENV EPICS_HOST_ARCH=linux-x86_64
ENV EPICS_ROOT="${APP_ROOT}/base"
ENV EPICS_VERSION="7.0.3"
ENV PATH="${PATH}:${EPICS_ROOT}/bin/${EPICS_HOST_ARCH}"


# 
WORKDIR ${APP_ROOT}
ADD https://epics.anl.gov/download/base/base-${EPICS_VERSION}.tar.gz ./

RUN tar xzf base-${EPICS_VERSION}.tar.gz && \
    rm      base-${EPICS_VERSION}.tar.gz && \
    ln -s   base-${EPICS_VERSION} base

WORKDIR ${EPICS_ROOT}
RUN make -j4 CFLAGS="-fPIC" CXXFLAGS="-fPIC" && \
    make clean

# --- Dev ---
# docker build -t kedokudo/epics-base:7.0.3 .
# docker run -it --rm kedokudo/epics-base:7.0.3 /bin/bash

FROM ubuntu:20.04

# Create A Normal User
# https://stackoverflow.com/questions/39855304/how-to-add-user-with-dockerfile
# https://askubuntu.com/questions/94060/run-adduser-non-interactively

RUN adduser --disabled-password -gecos "" a_normal_user


# Noninteractive install of tzdata
# https://stackoverflow.com/questions/44331836/apt-get-install-tzdata-noninteractive
ENV DEBIAN_FRONTEND=noninteractive


# Install Dependencies

RUN apt-get update && apt-get upgrade && \
    apt-get install -y --no-install-recommends tzdata \
    build-essential \
    uuid-dev \
    libgpgme-dev \
    squashfs-tools \
    libseccomp-dev \
    wget \
    pkg-config \
    git \
    cryptsetup-bin \
	python3-dev


# Install Go

ARG VERSION="1.14.12"
ARG OS="linux"
ARG ARCH="amd64"
RUN  wget --no-check-certificate https://dl.google.com/go/go${VERSION}.${OS}-${ARCH}.tar.gz && \
    tar -C /usr/local -xzvf go${VERSION}.${OS}-${ARCH}.tar.gz && \
    rm go${VERSION}.${OS}-${ARCH}.tar.gz


# RUN echo 'export GOPATH=${HOME}/go' >> ~/.bashrc && \
#     echo 'export PATH=/usr/local/go/bin:${PATH}:${GOPATH}/bin' >> ~/.bashrc && \
#     source /root/.bashrc

ENV GOPATH=/root/go
ENV PATH=/usr/local/go/bin:${PATH}:${GOPATH}/bin


# Download and compile Singularity from a release.
# By default Singularity will be installed in the /usr/local directory hierarchy. 

ARG SING_VERSION="3.7.0"
RUN wget --no-check-certificate \
    https://github.com/hpcng/singularity/releases/download/v${SING_VERSION}/singularity-${SING_VERSION}.tar.gz && \
    tar -xzf singularity-${SING_VERSION}.tar.gz && \
    cd singularity && \
	./mconfig && \
    make -C ./builddir && \
    make -C ./builddir install

# ---

ENV PATH="/usr/local/singularity/bin:$PATH" \
    SINGULARITY_TMPDIR="/tmp-singularity"


# RUN apk add --no-cache ca-certificates libseccomp squashfs-tools tzdata \
#     && mkdir -p $SINGULARITY_TMPDIR \
#     && cp /usr/share/zoneinfo/UTC /etc/localtime \
#     && apk del tzdata \
#     && rm -rf /tmp/* /var/cache/apk/*

USER a_normal_user
WORKDIR /home/a_normal_user
# ENTRYPOINT ["/usr/local/singularity/bin/singularity"]

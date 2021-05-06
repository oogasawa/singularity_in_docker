FROM ubuntu:20.04


# Noninteractive install of tzdata
# https://stackoverflow.com/questions/44331836/apt-get-install-tzdata-noninteractive
ENV DEBIAN_FRONTEND=noninteractive


# Install Dependencies of Singularity
# https://sylabs.io/guides/3.7/admin-guide/installation.html
# https://stackoverflow.com/questions/45165813/x509-certificate-signed-by-unknown-authority
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
	python3-dev \
	ca-certificates


# Install Go
# https://sylabs.io/guides/3.7/admin-guide/installation.html

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
# https://sylabs.io/guides/3.7/admin-guide/installation.html

ARG SING_VERSION="3.7.0"
RUN cd /usr/local/src && \
    wget --no-check-certificate \
    https://github.com/hpcng/singularity/releases/download/v${SING_VERSION}/singularity-${SING_VERSION}.tar.gz && \
    tar -xzf singularity-${SING_VERSION}.tar.gz && \
    cd singularity && \
	./mconfig && \
    make -C ./builddir && \
    make -C ./builddir install


# Settings for the singularity-in-docker
# https://github.com/kaczmarj/singularity-in-docker

ENV PATH="/usr/local/singularity/bin:$PATH" \
    SINGULARITY_TMPDIR="/tmp-singularity" 


# RUN apk add --no-cache ca-certificates libseccomp squashfs-tools tzdata \
#     && mkdir -p $SINGULARITY_TMPDIR \
#     && cp /usr/share/zoneinfo/UTC /etc/localtime \
#     && apk del tzdata \
#     && rm -rf /tmp/* /var/cache/apk/*



# Create a normal user and sudo privilege
# https://askubuntu.com/questions/94060/run-adduser-non-interactively
# https://stackoverflow.com/questions/25845538/how-to-use-sudo-inside-a-docker-container

RUN apt-get update \
 && apt-get install -y sudo && \
 rm /etc/localtime && \
 cp /usr/share/zoneinfo/Japan /etc/localtime 

RUN adduser -ms --disabled-password --gecos '' a_normal_user
RUN adduser a_normal_user sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN  mkdir -p ${SINGULARITY_TMPDIR} && chown -R a_normal_user ${SINGULARITY_TMPDIR}
RUN  mkdir /home/data

USER a_normal_user
WORKDIR /home/a_normal_user
# ENV  PS1="\u@\H:\w (\D{%F} \t)\n$ "
# ENTRYPOINT ["/usr/local/singularity/bin/singularity"]

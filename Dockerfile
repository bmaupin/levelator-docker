FROM ubuntu:18.04

ENV levelator_version=1.3.0-Python2.5
# This is where the levelator binaries will reside
ENV installdir=/opt/levelator
ENV PATH="${installdir}:${PATH}"
ENV PYTHONPATH="${installdir}/.levelator/levelator.zip"

WORKDIR ${installdir}

# Install dependencies
# No need to do any cleanup after running these commands (https://github.com/rocker-org/rocker/issues/35#issuecomment-58944297)
RUN dpkg --add-architecture i386 && \
    apt update && \
    apt install -y software-properties-common && \
    apt-add-repository -y ppa:deadsnakes/ppa && \
    apt install -y coreutils \
        curl \
        libc6:i386 \
        libflac8:i386 \
        libgcc1:i386 \
        libogg0:i386 \
        libsndfile1:i386 \
        libstdc++6:i386 \
        libvorbis0a:i386 \
        libvorbisenc2:i386 \
        python2.5

# Download and extract Levelator
RUN curl -LOs http://web.archive.org/web/20071010101022if_/http://cdn.conversationsnetwork.org/Levelator-${levelator_version}.tar.bz2 && \
    tar -xf Levelator-${levelator_version}.tar.bz2 --strip-components 1 && \
    rm Levelator-${levelator_version}.tar.bz2

# Install wrapper scripts
COPY levelator.sh .
COPY levelator.py .levelator/.

RUN \
    # Make wxPython import not fail
    mkdir .levelator/wx && \
    touch .levelator/wx/__init__.py && \
    # Update shell wrapper script
    sed -i 's@INSTALLDIR@'${installdir}'@' levelator.sh && \
    chmod +x levelator.sh

ENTRYPOINT ["levelator.sh"]

# Use a different working directory for input/output files; using the same directory would overwrite the binaries when mounting it as a volume
WORKDIR /levelator

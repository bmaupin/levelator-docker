FROM ubuntu:18.04

ENV levelator_version=Levelator-1.3.0-Python2.5
# This is where the levelator binary will reside
ENV installdir=/opt/levelator
ENV PATH="${installdir}:${PATH}"

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
RUN curl -LOs http://web.archive.org/web/20071010101022if_/http://cdn.conversationsnetwork.org/${levelator_version}.tar.bz2 && \
    tar -xf ${levelator_version}.tar.bz2 --strip-components 1 && \
    rm ${levelator_version}.tar.bz2 && \
    chmod +x levelator

# Install Python wrapper script
COPY levelator.py .levelator/levelator.py

RUN \
    # Make wxPython import not fail
    mkdir .levelator/wx && \
    touch .levelator/wx/__init__.py && \
    # Update the shell wrapper script so it can be run from anywhere
    sed -i.bak 's/^cd.*/#/' levelator && \
    sed -i 's_export PYTHONPATH=levelator.zip_export PYTHONPATH='$(pwd)'/.levelator/levelator.zip_' levelator && \
    # Point to the Python wrapper script and pass the full paths of input/output files
    sed -i 's_python main.py_python2.5 '$(pwd)'/.levelator/levelator.py $(readlink -f "$1") $(readlink -f "$2")_' levelator

ENTRYPOINT ["levelator"]

# Use a different working directory for input/output files to keep them separate from levelator binaries
WORKDIR /levelator

# Using a 32-bit image takes up less space as opposed to a 64-bit image with 32-bit libraries
FROM i386/ubuntu

ARG levelator_version=1.3.0-Python2.5

WORKDIR /levelator

ADD http://web.archive.org/web/20071010101022if_/http://cdn.conversationsnetwork.org/Levelator-${levelator_version}.tar.bz2 .
COPY levelator.sh /usr/local/bin/levelator

# Install dependencies
# No need to do any cleanup after running these commands (https://github.com/rocker-org/rocker/issues/35#issuecomment-58944297)
RUN apt update && \
    apt install -y \
        libsndfile1:i386 \
        libstdc++6:i386

RUN tar -xvf Levelator-${levelator_version}.tar.bz2 && \
    mv Levelator-${levelator_version}/.levelator/linux/level /usr/local/bin && \
    chmod +x /usr/local/bin/level && \
    rm -rf Levelator-${levelator_version}*

ENTRYPOINT ["/usr/local/bin/levelator"]

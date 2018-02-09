FROM ubuntu:latest

MAINTAINER Wietse Wind <mail@wietse.com>

RUN export LANGUAGE=C.UTF-8; export LANG=C.UTF-8; export LC_ALL=C.UTF-8; export DEBIAN_FRONTEND=noninteractive

COPY entrypoint /entrypoint.sh

RUN apt-get update -y && \
    apt-get install yum-utils alien ssh openssl nano -y && \
    cd /tmp && \
    wget https://mirrors.ripple.com/ripple-repo-el7.rpm && \
    rpm -Uvh ripple-repo-el7.rpm && \
    yumdownloader --enablerepo=ripple-stable --releasever=el7 rippled && \
    wget https://mirrors.ripple.com/rpm/RPM-GPG-KEY-ripple-release && \
    rpm --import RPM-GPG-KEY-ripple-release && rm RPM-GPG-KEY-ripple-release && rpm -K rippled*.rpm && \
    alien -i --scripts rippled*.rpm && rm rippled*.rpm && \
    rm -rf /var/lib/apt/lists/* && \
    export PATH=$PATH:/opt/ripple/bin/ && \
    chmod +x /entrypoint.sh && \
    echo '#!/bin/bash' > /usr/bin/server_info && echo '/entrypoint.sh server_info' >> /usr/bin/server_info && \
    chmod +x /usr/bin/server_info

RUN ln -s /opt/ripple/bin/rippled /usr/bin/rippled

EXPOSE 80 443 5005 6006 51235

ENTRYPOINT [ "/entrypoint.sh" ]

# This is based on Debian 8.8 (jessie)
FROM google/cloud-sdk:159.0.0-slim

####################
# Helper scripts
####################
ADD /scripts /scripts
ENV PATH="/scripts:${PATH}"

####################
# Needed by various npm/bower package installs
####################
RUN \
    apt-get update && \
    apt-sparse-install \
        build-essential=11.7 \
        bzip2 \
        git

####################
# Docker client
# (see http://docs.master.dockerproject.org/engine/installation/linux/debian/#/debian-jessie-80-64-bit)
####################
RUN \
    apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D && \
    echo "deb https://apt.dockerproject.org/repo debian-jessie main" > /etc/apt/sources.list.d/docker.list && \
    apt-get update && \
    apt-sparse-install \
        docker-engine=17.05.0~ce-0~debian-jessie

####################
# Node
# (see https://nodejs.org/en/download/package-manager/#debian-and-ubuntu-based-linux-distributions)
####################
RUN \
    curl -sL https://deb.nodesource.com/setup_8.x | bash - && \
    apt-sparse-install \
        nodejs=8.1.2-1nodesource1~jessie1

####################
# Yarn
# (see https://yarnpkg.com/lang/en/docs/install/#linux-tab)
# Note that we don't just npm install it due to some CircleCI freakout
# (see https://discuss.circleci.com/t/failed-to-register-layer-error-processing-tar-file-exit-status-1-container-id-249512-cannot-be-mapped-to-a-host-id/13453/5)
####################
RUN \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list && \
    apt-get update && \
    apt-sparse-install \
        yarn=0.24.6-1

####################
# Bower
# (Note the need to work around Bower's arrogant BS due to it assuming it's running via sudo)
####################
RUN \
    yarn global add bower@1.8.0 && \
    echo '{ "allow_root": true }' > /root/.bowerrc

####################
# JDK
####################
RUN \
    echo "deb http://http.debian.net/debian jessie-backports main" >> /etc/apt/sources.list.d/jessie-backports.list && \
    apt-get update && \
    apt-sparse-install -t jessie-backports \
        openjdk-8-jdk=8u131-b11-1~bpo8+1

####################
# Python
####################
# TODO
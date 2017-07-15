# This is based on Debian 8.8 (jessie)
FROM google/cloud-sdk:159.0.0-slim

RUN \
    # Docker client
    # (see http://docs.master.dockerproject.org/engine/installation/linux/debian/#/debian-jessie-80-64-bit)
    apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D && \
    echo "deb https://apt.dockerproject.org/repo debian-jessie main" > /etc/apt/sources.list.d/docker.list && \

    # Node
    # (see https://nodejs.org/en/download/package-manager/#debian-and-ubuntu-based-linux-distributions)
    curl -sL https://deb.nodesource.com/setup_8.x | bash - && \

    # Yarn
    # (see https://yarnpkg.com/lang/en/docs/install/#linux-tab)
    # Note that we don't just npm install it due to some CircleCI freakout
    # (see https://discuss.circleci.com/t/failed-to-register-layer-error-processing-tar-file-exit-status-1-container-id-249512-cannot-be-mapped-to-a-host-id/13453/5)
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list && \

    # JDK
    echo "deb http://http.debian.net/debian jessie-backports main" >> /etc/apt/sources.list.d/jessie-backports.list && \

    # Finally
    apt-get update && \
    apt-get install --no-install-recommends -y \
        docker-engine=17.05.0~ce-0~debian-jessie \
        nodejs=8.1.4-2nodesource1~jessie1 \
        yarn=0.24.6-1 \
        # Other required things
        build-essential=11.7 \
        bzip2 \
        git \
        rsync \
        ssh && \
    apt-get install --no-install-recommends -y -t jessie-backports \
        openjdk-8-jdk=8u131-b11-1~bpo8+1 && \
    rm -rf /var/lib/apt/lists/*

# # Downgrade to NPM 4, because NPM 5 is utterly raging
# RUN npm install -g npm@4.6.1

# Helper scripts
ADD /scripts /scripts
ENV PATH="/scripts:${PATH}"

FROM debian:9.1

# Prerequisites
RUN \
    apt-get update && \
    apt-get install --no-install-recommends -y \
        curl \
        apt-transport-https \
        ca-certificates \
        gnupg && \
    rm -rf /var/lib/apt/lists/*

RUN \
    # GCloud SDK
    # (see https://cloud.google.com/sdk/docs/quickstart-debian-ubuntu)
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    echo "deb http://packages.cloud.google.com/apt cloud-sdk-stretch main" > /etc/apt/sources.list.d/google-cloud-sdk.list && \

    # Docker client
    # (see https://docs.docker.com/engine/installation/linux/docker-ce/debian/)
    curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
    echo "deb [arch=amd64] https://download.docker.com/linux/debian stretch stable" > /etc/apt/sources.list.d/docker.list && \

    # Node
    # (see https://nodejs.org/en/download/package-manager/#debian-and-ubuntu-based-linux-distributions, we've extracted
    # the salient content of the installation script)
    curl -s https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - && \
    echo 'deb https://deb.nodesource.com/node_8.x stretch main' > /etc/apt/sources.list.d/nodesource.list && \
    echo 'deb-src https://deb.nodesource.com/node_8.x stretch main' >> /etc/apt/sources.list.d/nodesource.list && \

    # Yarn
    # (see https://yarnpkg.com/lang/en/docs/install/#linux-tab)
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list && \

    # Finally
    apt-get update && \
    apt-get install --no-install-recommends -y \
        google-cloud-sdk=172.0.1-0 \
        docker-ce=17.06.2~ce-0~debian \
        nodejs=8.6.0-1nodesource1 \
        yarn=1.0.2-1 \
        ruby=1:2.3.3 ruby-dev=1:2.3.3 \
        python3=3.5.3-1 python3-pip=9.0.1-2 python3-venv=3.5.3-1 \
        openjdk-8-jdk=8u141-b15-1~deb9u1 \
        # Other required things
        aspell=0.60.7~20110707-3+b2 aspell-en=2016.11.20-0-0.1 \
        build-essential=12.3 \
        bzip2 \
        git \
        rsync \
        ssh \
        unzip && \
    rm -rf /var/lib/apt/lists/*

# Because NPM is raging
RUN npm uninstall -g npm

# Install Terraform (see https://github.com/hashicorp/docker-hub-images/blob/master/terraform/Dockerfile-light)
RUN \
    curl https://releases.hashicorp.com/terraform/0.10.2/terraform_0.10.2_linux_amd64.zip > terraform.zip && \
    unzip terraform.zip -d /bin && \
    rm terraform.zip

RUN useradd -ms /bin/bash quartic

# Helper scripts
ADD /scripts /scripts
ENV PATH="/scripts:/home/quartic/.gem/bin:${PATH}"

USER quartic

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

# Install Bundler (and disable warning given that we have to run as root)
ENV GEM_HOME="/home/quartic/.gem"
RUN \
    gem install bundler -v 1.15.3 && \
    bundle config --global silence_root_warning 1

WORKDIR /home/quartic

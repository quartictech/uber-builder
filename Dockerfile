FROM debian:9.1

# APT repos
ADD /apt/keys /keys
RUN \
    apt-get update && \
    apt-get install --no-install-recommends -y gnupg && \
    apt-key add /keys/* && \
    rm -rf /keys && \
    rm -rf /var/lib/apt/lists/*
ADD /apt/sources.list.d/ /etc/apt/sources.list.d

RUN \
    # Finally
    apt-get update && \
    apt-get install --no-install-recommends -y \
        google-cloud-sdk=173.0.0-0 \
        kubectl=1.7.5-00 \
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

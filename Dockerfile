# This is based on Debian 8.8 (jessie)
FROM google/cloud-sdk:166.0.0-slim

RUN \
    # Docker client
    # (see https://docs.docker.com/engine/installation/linux/docker-ce/debian/)
    curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
    echo "deb [arch=amd64] https://download.docker.com/linux/debian jessie stable" > /etc/apt/sources.list.d/docker.list && \

    # Yarn
    # (see https://yarnpkg.com/lang/en/docs/install/#linux-tab)
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list && \

    # JDK
    echo "deb http://http.debian.net/debian jessie-backports main" >> /etc/apt/sources.list.d/jessie-backports.list && \

    # Finally
    apt-get update && \
    apt-get install --no-install-recommends -y \
        docker-ce=17.06.0~ce-0~debian \
        yarn=1.0.2-1 \
        ruby=1:2.1.5+deb8u2 ruby-dev=1:2.1.5+deb8u2 \
        python3-venv=3.4.2-2 \
        # Other required things
        aspell=0.60.7~20110707-1.3 aspell-en=7.1-0-1.1 \
        build-essential=11.7 \
        bzip2 \
        git \
        rsync \
        ssh \
        unzip && \
    apt-get install --no-install-recommends -y -t jessie-backports \
        openjdk-8-jdk=8u131-b11-1~bpo8+1 && \
    rm -rf /var/lib/apt/lists/*

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

# Install Bundler (and disable warning given that we have to run as root)
ENV GEM_HOME="/home/quartic/.gem"
RUN \
    gem install bundler -v 1.15.3 && \
    bundle config --global silence_root_warning 1

WORKDIR /home/quartic

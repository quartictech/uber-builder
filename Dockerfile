FROM google/cloud-sdk:159.0.0-slim

# We need to sudo npm install, due to CircleCI uid/gid weirdness
# (see https://discuss.circleci.com/t/failed-to-register-layer-error-processing-tar-file-exit-status-1-container-id-249512-cannot-be-mapped-to-a-host-id/13453/5)
RUN apt-get install -y sudo bzip2

# Node (see https://nodejs.org/en/download/package-manager/#debian-and-ubuntu-based-linux-distributions)
RUN \
    curl -sL https://deb.nodesource.com/setup_8.x | bash - && \
    apt-get install -y nodejs=8.1.2-1nodesource1~jessie1

# Yarn (see https://yarnpkg.com/lang/en/docs/install/#linux-tab)
RUN \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && \
    apt-get install -y yarn

# Bower
RUN yarn global add bower@1.8.0

# # Add stuff
# ADD gcloud-auth /scripts/
# ENV PATH="/scripts:${PATH}"

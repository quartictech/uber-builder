FROM google/cloud-sdk:159.0.0-slim

# Needed for various npm/bower package installs
RUN apt-get install -y \
    build-essential \
    bzip2 \
    git

# Node (see https://nodejs.org/en/download/package-manager/#debian-and-ubuntu-based-linux-distributions)
RUN \
    curl -sL https://deb.nodesource.com/setup_8.x | bash - && \
    apt-get install -y nodejs=8.1.2-1nodesource1~jessie1

# Yarn (see https://yarnpkg.com/lang/en/docs/install/#linux-tab)
# Note that we don't just npm install it due to some CircleCI freakout
# (see https://discuss.circleci.com/t/failed-to-register-layer-error-processing-tar-file-exit-status-1-container-id-249512-cannot-be-mapped-to-a-host-id/13453/5)
RUN \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && \
    apt-get install -y yarn

# Bower
# (Note the need to work around Bower's arrogant BS due to assuming it's running via sudo)
RUN \
    yarn global add bower@1.8.0 && \
    echo '{ "allow_root": true }' > /root/.bowerrc

# Add stuff
ADD gcloud-auth /scripts/
ENV PATH="/scripts:${PATH}"

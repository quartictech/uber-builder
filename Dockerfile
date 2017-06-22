FROM google/cloud-sdk:159.0.0-slim

# Node (see https://nodejs.org/en/download/package-manager/#debian-and-ubuntu-based-linux-distributions)
RUN \
    curl -sL https://deb.nodesource.com/setup_8.x | bash - && \
    apt-get install -y nodejs=8.1.2-1nodesource1~jessie1

# Yarn
RUN npm install --global yarn@0.24.6

# Bower
RUN yarn global add bower@1.8.0

# Add stuff
ADD gcloud-auth /scripts/
ENV PATH="/scripts:${PATH}"
# Fix for CircleCI uid/gid weirdness (see https://discuss.circleci.com/t/failed-to-register-layer-error-processing-tar-file-exit-status-1-container-id-249512-cannot-be-mapped-to-a-host-id/13453/5)
RUN chown -R root:root /scripts

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
        nodejs=8.1.2-1nodesource1~jessie1 \
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

RUN apt-get update && apt-get install unzip && \
    mkdir -p /usr/local/android-sdk-linux && \
    curl -o tools.zip https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip && \
    unzip tools.zip -d /usr/local/android-sdk && \
    rm tools.zip

# Add android tools and platform tools to PATH
ENV ANDROID_HOME /usr/local/android-sdk
ENV PATH=${ANDROID_HOME}/emulator:${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools:${PATH}
RUN mkdir ~/.android && echo '### User Sources for Android SDK Manager' > ~/.android/repositories.cfg

RUN sdkmanager --update && yes | sdkmanager --licenses

# Update and install using sdkmanager RUN $ANDROID_HOME/tools/bin/sdkmanager "tools" "platform-tools"
RUN sdkmanager \
  "tools" \
  "platform-tools" \
  "emulator" \
  "extras;android;m2repository" \
  "extras;google;m2repository" \
  "extras;google;google_play_services"

RUN sdkmanager \
  "build-tools;25.0.3" \
  "platforms;android-25" \
  "system-images;android-25;google_apis;armeabi-v7a"

# Helper scripts
ADD /scripts /scripts
ENV PATH="/scripts:${PATH}"
RUN echo "no" | /usr/local/android-sdk/tools/android create avd -f -n test -k "system-images;android-25;google_apis;armeabi-v7a" --abi 'google_apis/armeabi-v7a'

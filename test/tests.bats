#!/usr/bin/env bats

@test "NPM can install things" {
    npm install redux@3.7.0
    npm uninstall redux
}

# This command failed with Node 8.1.2 (=> NPM 5.0.3)
@test "NPM can install stuff without breaking" {
    npm install --global --no-save --prefix yarn yarn@0.27.5
}

@test "Yarn can install things" {
    yarn add redux@3.7.0
    yarn remove redux
}

@test "Yarn can install package that needs make" {
    yarn add time@0.12.0
    yarn remove time
}

@test "Yarn can install package that needs bzip2" {
    yarn add phantomjs-prebuilt@2.1.14
    yarn remove phantomjs-prebuilt
}

@test "Java can compile and run Java8 things" {
    javac Hello.java
    java Hello
}

@test "Rsync is installed" {
    touch foo.txt
    rsync foo.txt bar.txt
}

@test "Git is installed" {
    git clone https://github.com/reactjs/redux.git
}

@test "SSH is installed" {
    # This is kind of lame, but a more useful functional tests would require registering keys, etc.
    ssh -V
}

@test "Can authenticate to GCloud" {
    gcloud-auth
    gcloud compute instances list
}

# This will also fail if Docker client isn't installed
@test "Can login to GCloud Docker registry" {
    skip "Unclear how to run dockerd inside Docker inside Docker inside..."
    gcloud-auth --with-docker
    docker pull eu.gcr.io/quartictech/scheduled-jobs:85  # Some random image (the smallest one I could find)
}
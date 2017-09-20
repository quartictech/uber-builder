#!/usr/bin/env bats

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
    ./gradlew compileJava
}

# We specifically care about Jekyll for now
@test "Ruby Bundler can install Jekyll" {
    bundle install
}

@test "Can create a Python3 virtualenv" {
    python3 -m venv .env
    source .env/bin/activate
    python -c 'print("Hello")'      # Would fail if Python 2
}

@test "Aspell can check for GB spelling" {
    test "color" == "$(echo 'color colour' | aspell list -l en_GB)"
}

@test "Rsync is installed" {
    touch foo.txt
    rsync foo.txt bar.txt
}

@test "Git is installed" {
    git clone https://github.com/reactjs/redux.git
}

@test "Terraform is installed" {
    terraform init
    terraform validate
}

# This is kind of lame, but a more useful functional tests would require registering keys, etc.
@test "SSH is installed" {
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
#!/usr/bin/env bats

@test "Kubectl is installed" {
    kubectl version -c   # -c because no server available here
}

@test "Can authenticate to GCloud" {
    google-cloud-auth
    gcloud container images list    # Using this particular command because service account can basically do only this
}

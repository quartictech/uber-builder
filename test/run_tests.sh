#!/bin/bash
set -eu
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

git clone https://github.com/sstephenson/bats.git
pushd bats
./install.sh /home/quartic/bats
popd

pushd ${DIR}
/home/quartic/bats tests.bats
popd
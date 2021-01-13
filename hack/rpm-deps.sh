#!/usr/bin/env bash

set -ex

source hack/common.sh
source hack/config.sh

LIBVIRT_VERSION=0:6.6.0-8
SEABIOS_VERSION=0:1.14.0-1
QEMU_VERSION=15:5.1.0-16

# Define some base packages to avoid dependency flipping
# since some dependencies can be satisfied by multiple packages
basesystem="glibc-langpack-en coreutils-single libcurl-minimal curl-minimal fedora-logos-httpd vim-minimal"

# get latest repo data from repo.yaml
bazel run \
    --config=${ARCHITECTURE} \
    //:bazeldnf -- fetch

# create a rpmtree for virt-launcher and virt-handler. This is the OS for our node-components.
bazel run \
    --config=${ARCHITECTURE} \
    //:bazeldnf -- rpmtree --public --arch=aarch64 --name libvirt-devel_aarch64 $basesystem libvirt-devel-${LIBVIRT_VERSION}

bazel run \
    --config=${ARCHITECTURE} \
    //:bazeldnf -- prune

bazel build \
    --config=${ARCHITECTURE} \
    //rpm:libvirt-devel_aarch64

bazel run \
    --config=${ARCHITECTURE} \
    //rpm:ldd_aarch64

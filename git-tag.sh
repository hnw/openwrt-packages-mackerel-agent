#! /usr/bin/env bash

set -eu

if [[ "$(find . -name Makefile | wc -l)" -ne "1" ]]; then
    if [[ "$(find . -name Makefile | wc -l)" -eq "0" ]]; then
        echo "Error: Not found Makefile. Exited."
    else
        echo "Error: multiple Makefile found. Exited."
    fi
else
    MAKEFILE_PATH=$(find . -name Makefile)
    PKG_VERSION=$(grep '^PKG_VERSION:=' ${MAKEFILE_PATH} | sed -e 's/^PKG_VERSION:=//')
    PKG_RELEASE=$(grep '^PKG_RELEASE:=' ${MAKEFILE_PATH} | sed -e 's/^PKG_RELEASE:=//')
    TAG=${PKG_VERSION}-${PKG_RELEASE}
    if [[ -n "$(git tag -l ${TAG})" ]]; then
        echo "Already exist tag: ${TAG}"
        echo "Do nothing."
    else
        git config --global "url.git@github.com:.pushinsteadof" "https://github.com/"
        git config --global user.name "Travis CI"
        git config --global user.email "travis@example.com"
        mkdir -p $HOME/.ssh
        chmod 700 $HOME/.ssh
        openssl aes-256-cbc -K $encrypted_bf6e97fa5995_key -iv $encrypted_bf6e97fa5995_iv -in deploy_key.enc -out $HOME/.ssh/id_ecdsa -d
        chmod 600 $HOME/.ssh/id_ecdsa
        echo git tag $TAG
        git tag ${TAG}
        echo git push origin $TAG
        git push origin ${TAG}
    fi
fi

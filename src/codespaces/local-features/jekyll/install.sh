#!/usr/bin/env bash
#-------------------------------------------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See https://go.microsoft.com/fwlink/?linkid=2090316 for license information.
#-------------------------------------------------------------------------------------------------------------
#
# Docs: https://github.com/microsoft/vscode-dev-containers/blob/main/script-library/docs/hugo.md
# Maintainer: The VS Code and Codespaces Teams
#
# Syntax: ./jekyll-debian.sh [Jekyll version] [Non-root user] [Add rc files flag]

VERSION=${1:-"latest"}
USERNAME=${2:-"codespace"}

set -e

# If we don't yet have Ruby installed, exit.
if ! /usr/local/rvm/rubies/default/bin/ruby --version > /dev/null ; then
    echo "You need to install Ruby before installing Jekyll."
    exit 1
fi

# If we don't already have Jekyll installed, install it now.
if ! jekyll --version > /dev/null ; then
    echo "Installing Jekyll..."
    
    GEMS_DIR=/usr/local/rvm/rubies/default/bin
    PATH=$GEMS_DIR/gem:$PATH
    if [ "${VERSION}" = "latest" ]; then
        gem install jekyll
    else
        gem install jekyll -v "${VERSION}"
    fi

    chown -R "${USERNAME}:rvm" "${GEMS_DIR}/"
    chmod -R g+r+w "${GEMS_DIR}/"
    find "${GEMS_DIR}" -type d | xargs -n 1 chmod g+s
fi

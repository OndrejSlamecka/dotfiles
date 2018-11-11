#!/usr/bin/sh
# Configuration for PATH, XDG* and similar variables

export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache

NPM_PACKAGES="${HOME}/.local/npm-packages"

export PATH="${PATH}:$NPM_PACKAGES/bin:$HOME/.local/bin"

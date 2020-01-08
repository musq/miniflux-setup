#!/usr/bin/env bash

# https://superuser.com/a/202654

CURRENT_DIR="$(readlink -f $(dirname "${BASH_SOURCE[0]}"))"

DOMAIN="read.tug.ro"
USER="$(whoami)"

DOTFILES_SYSTEM_DIR="$CURRENT_DIR/../dotfiles-system"
DOTFILES_SYSTEM_GIT_REPO="https://github.com/musq/dotfiles-system.git"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Setup dotfiles-system dir

if [ ! -d "$DOTFILES_SYSTEM_DIR" ]; then

    git clone --recurse-submodules \
        "$DOTFILES_SYSTEM_GIT_REPO" \
        "$DOTFILES_SYSTEM_DIR"

fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Source utility functions

. "$DOTFILES_SYSTEM_DIR/src/os/utils.sh" \
    && . "$DOTFILES_SYSTEM_DIR/src/os/contract/utils.sh" \
    && . "$DOTFILES_SYSTEM_DIR/src/os/install/nix/utils.sh"

cd "$CURRENT_DIR"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Ask sudo password, if necessary

if [ "$(user_has_sudo)" != "no_sudo" ]; then
    ask_for_sudo
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Postgres

print_in_purple "\n ● Postgres\n\n"

execute \
    "$NIX_DEFAULT_BIN/createuser miniflux" \
    "Create user: miniflux" \
    "sudo" \
    "postgres"

execute \
    "$NIX_DEFAULT_BIN/createdb \
        --owner=miniflux \
        miniflux" \
    "Create database: miniflux" \
    "sudo" \
    "postgres"

execute \
    "$NIX_DEFAULT_BIN/psql \
        miniflux -c \\\"CREATE EXTENSION IF NOT EXISTS hstore\\\"" \
    "Create extension: hstore" \
    "sudo" \
    "postgres"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Miniflux

print_in_purple "\n ● Miniflux\n\n"

nix_install "Miniflux" "nixpkgs.miniflux"

add_user "miniflux" "Miniflux" "system"

# execute \
#     "miniflux -config-file $(pwd)/miniflux.conf -migrate"
#     "Run migrations"
#     "sudo"

# Create miniflux user account

create_symlink "$(pwd)/miniflux.service" "/lib/systemd/system/miniflux.service" "-y"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Nginx

print_in_purple "\n ● Nginx\n\n"

create_symlink \
    "$(pwd)/$DOMAIN.conf" \
    "/etc/nginx/conf.d/$DOMAIN.conf" "-y"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Systemd

print_in_purple "\n ● Systemd\n\n"

execute \
    "systemctl enable miniflux \
        && systemctl reload-or-restart miniflux" \
    "Reload Miniflux" \
    "sudo"

execute \
    "systemctl enable nginx \
        && systemctl reload-or-restart nginx" \
    "Reload Nginx" \
    "sudo"

print_in_purple "\n"

#!/usr/bin/env bash

root="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

function usage {
    printf "
Usage: new-project.sh <params>

Possible parameters:
--project-name=<project name used for docker compose images>
--branch=<php56-api or php71-api>

"
    exit 1
}

libVersion="1.0.2"

function importLib {
    removeLib
    printf  "\ndownloading files...\n"
    mkdir bash-scripts-$libVersion
    wget "https://github.com/vceratti/bash-scripts/archive/$libVersion.tar.gz" &> /dev/null
    tar -xf "$libVersion.tar.gz"
    rm "$libVersion.tar.gz"

}

function removeLib {
    find . -type d -name "bash-scripts-*" -exec rm -rf {} \; &> /dev/null
}

importLib

source "$root/bash-scripts-$libVersion/lib.sh"


function install_php_build {
    if should_run_command "Install development environment?    This will checkout build files and install some tools (like Ant and Docker)"; then
        checkout_build_repo

        cd "build"
        chmod +x install-php-build.sh
        ./install-php-build.sh --project-name="$project_name"

        mv  docker-compose.yml "$root/docker-compose.yml"
        mv  php-build "$root/php-build"

        cd "$root"
    fi
}

function composer_update {
    if should_run_command "Run composer update?"; then
        checkout_build_repo
        cd build
        chmod +x install.sh
        exec ./install.sh
        php="docker exec -it php-build7.1 php -i"
        cd "$root"
    fi

}


function clean {
    log_ask_newline "Root access required for apt-get and Docker permissions"

    sudo ls &> /dev/null

    log_wait "Cleaning old files (./mysql /build /vendor)"

    sudo rm -rf build .mysql vendor &> /dev/null
    sudo rm docker-php-build-up.sh docker-compose.yml php-build &> /dev/null

    log_done
}


function main {
    log_title "API Generator"
    clean
    choose_project_name
    check_install "git"
    choose_env

    install_php_build
    removeLib

}

main

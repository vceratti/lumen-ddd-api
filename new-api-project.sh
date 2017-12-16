#!/usr/bin/env bash

root="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

function usage {
    printf "
Usage: new-project.sh <params>

Possible parameters:
--project-name=<project name used for docker compose images>
--branch=<php56-api or php71-api>
--disable-docker-check=true
"
    exit 1
}

libVersion="1.0.11"

function importLib {
    removeLib
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
    checkout_build_repo
    echo ""
    cd ".build"
    chmod +x install-php-build.sh
    ./install-php-build.sh "--disable-docker-check=true" "--branch=${branch}" "--project-name=${project_name}"

    cd "$root"
}

function clean {
    log_ask_newline "Root access required for apt-get and Docker permissions"

    sudo ls &> /dev/null

    log_wait "Cleaning old files (./.mariadb /.build /vendor)"

    sudo rm -rf .build .mariadb vendor &> /dev/null
    sudo rm  ant-build artisan composer composer.lock docker-compose.yml &> /dev/null

    log_done
}


function main {
    log_title "API Generator"
    clean
    choose_project_name
    install_docker_and_compose
    choose_env

    install_php_build

    sudo chmod +x ./artisan ./composer ./ant-buid &> /dev/null

    sed -i -e "s/<project-name>/${project_name}/g" ./src/.env.example
    sed -i -e  "s/.build\///g" ./.gitignore
    rm ./new-api-project.sh ./README.md
    rm -Rf .git

    removeLib
}

main

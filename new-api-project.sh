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

libVersion="1.0.3"

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

        cd ".build"
        chmod +x install-php-build.sh
        ./install-php-build.sh --project-name="$project_name"

        cd "$root"
    fi
}

function create_tools_scripts {
    log "Creating Artisan and Composer executables"
    echo "#!/usr/bin/env bash" > ./artisan && \
    echo "docker-compose up -d" >> ./artisan
    echo "docker exec -it ${project_name}_php_build php ./src/artisan \$@" >> ./artisan
    printf "docker exec -it ${project_name}_php_build chown -R " >> ./artisan
    printf '`stat -c "%%u:%%g" .` .' >> ./artisan

    echo "#!/usr/bin/env bash" > ./composer && \
    echo "docker-compose up -d" >> ./composer
    echo "docker exec -it ${project_name}_php_build composer \$@" >> ./composer
    printf "docker exec -it ${project_name}_php_build chown -R " >> ./composer
    printf '`stat -c "%%u:%%g" .` ./vendor' >> ./composer

    sudo chmod +x ./artisan ./composer

}
function composer_update {
    if should_run_command "Run composer update?"; then
        checkout_build_repo
        cd .build
        chmod +x install.sh
        exec ./install.sh
        php="docker exec -it php_build7.1 php -i"
        cd "$root"
    fi

}


function clean {
    log_ask_newline "Root access required for apt-get and Docker permissions"

    sudo ls &> /dev/null

    log_wait "Cleaning old files (./.mariadb /.build /vendor)"

    sudo rm -rf build .mariadb vendor &> /dev/null
    sudo rm docker-php_build-up.sh docker-compose.yml ant-build composer.lock artisan composer &> /dev/null

    log_done
}


function main {
    log_title "API Generator"
    clean
    choose_project_name
    check_install "git"
    choose_env

    install_php_build
    create_tools_scripts
    removeLib

}

main

#!/usr/bin/env bash

# include sh with functions to ask, check and install apt packages
root="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

project_name=""
branch=""

function usage {
    printf "
Usage: new-project.sh <options>

Possible parameters:
--project-name=<project name used for docker compose images>
--branch=<php56-api or php71-api>

"
    exit 1
}

args="project-name:,branch:"

OPTIONS=$(getopt -o a: --long ${args} -- "$@" 2> /dev/null)

if [[ $? -ne 0 ]]
then
    usage
fi

eval set -- "$OPTIONS"

while true ; do
    case "$1" in
        --project-name ) project_name="${2}"; shift 2;;
        --branch ) branch="${2}"; shift 2;;
        --  ) shift; break;;
        * ) echo $1; usage;;
    esac
done

php="php"
git_token_php_build="5e2cd84c632e063ff21675e6c65387a9556236c1"

function error {
    print_l $1
    exit 1
}

function print_l {
    text=$@
    echo "$@"
    echo ''
}

function empty_str_cmd {
    cmd_return="$1"

    if [ "$cmd_return" = "" ]; then
        return 0;
    fi;
    return 1
}

function is_installed {
    app_name=$1

    isInstalled=`dpkg-query -s "$app_name" 2> /dev/null | grep -isE 'status: install ok'`

    if empty_str_cmd "$isInstalled"; then
        return 1
    fi
    return 0
}

function apt_install {
    app=$1
    echo ""
    print_l "Installing $app (may ask root permission)... "
    sudo apt-get -y install "$app" &> /dev/null
}

function check_install {
    app=$1

    printf " --- Checking $app installation ... "

    if ! is_installed "$app"; then
        apt_install "$app"
    fi
    if ! is_installed "$app"; then
        error "Could not install $app; please install it and re-run this script"

    fi
    printf "$app installed!\n"
}
function should_run_command {
    read -p " --- $1 (y/n)? " choice

    case "$choice" in
      y|Y ) return 0;;
      n|N ) return 1;;
      * ) return 1;;
    esac
}

function ask_and_install {
    cmd=$1

    if should_run_command " --- Check and install $cmd"; then
        check_install "$cmd"
    fi
}

function checkout_build_repo {
    echo " --- Checking out and installing build-tools"

    rm -rf build
    mkdir build
    cd build
    git init  &> /dev/null
    git pull "https://$git_token_php_build@github.com/vceratti/php-build-tools.git" "$branch" &> /dev/null

    cd "$root"
}
function install_php_build {
    if should_run_command "Install development environment?    This will checkout build files and install some tools (like Ant and Docker)"; then
        checkout_build_repo

        cd "build"
        chmod +x install-php-build.sh
        ./install-php-build.sh --project-name="$project_name"
        cd "$root"
#        mv build "$api_path/build"
        mv  docker-compose.yml "$root/docker-compose.yml"
        mv  docker-php-build-up.sh "$root/docker-php-build-up.sh"
        mv  php-build "$root/php-build"
    fi
}

function start_lumen_api {
    if should_run_command "Run composer and start a Lumen project?"; then
        checkout_build_repo
        cd build
        chmod +x install.sh
        exec ./install.sh
        php="docker exec -it php-build7.1 php -i"
        cd "$root"
    fi

}


function choose_env {
    if [[ ! $branch =~ php56\-api|php71\-api ]]; then
        branch=""
    fi;

    while empty_str_cmd "$branch"; do
        printf ' --- Choose an environment setting: \n'
        printf ' 1) PHP 7.1 and MariaDB (latest)\n'
        printf ' 2) PHP 5.6 and MySQL 5.6   '

        read -r env

        if (( env == 1 )); then
            branch="php71-api"
        fi

        if (( env == 2 )); then
            branch="php56-api"
        fi

        printf "\n"
   done;
}

function clean {
    printf ' --- Cleaning old files (./mysql /build /vendor) ... '
    sudo rm -rf build .mysql vendor &> /dev/null
    sudo rm docker-up.sh docker-compose.yml php.sh &> /dev/null

    printf "Done!\n"
}

function make_folders {
    sudo rm -rf src test build
    mkdir "src"
    mkdir "test"
}

function choose_project_name {
    while empty_str_cmd "$project_name"; do

        printf ' --- Choose a project name: '

        read -r project_name
    done

    printf "\n\tYour project name is: $project_name \n\n"
}

function main {
    printf "\n  ---- API Generator ----- \n\n"
    clean
    make_folders
    choose_project_name
    check_install "git"
    choose_env

    install_php_build
#    start_lumen_api
#    idea_settings

}

main

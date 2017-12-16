# lumen-ddd-api
A project for quick starting a REST API made with Lumen, using DDD and TDD (BDD?) and build/qa tools for continuous integration.

# Installation

Clone this repository in your project folder and run the installer:

```bash
git clone https://github.com/vceratti/lumen-ddd-api.git . &&
chmod +x ./new-api-project.sh.sh &&
./new-api-project.sh.sh
```

This installer will (may as for root permissions):

* ask for a project name, which will be used for docker containers and database name, PHPStorm configs, etc...

* check for Docker and Docker composer install (ant try to install them if they're not already present)

* download build repository and set up dev environment with Docker Compose. 

* generate executables for ant, composer and artisan (scripts calling executes those tools on docker machine)

* DELETE this installer, readme and git folder

# Work to do

This is a work in progress. The next steps are:

* a complete DDD structure

* replace PHP unit with some BDD tool (maybe)

* check for new build tools

* include some usual modules like users and authentication


### Mantainer  ###

Vinícius Ceratti

_v.ceratti@gmail.com_ |  _linkedin.com/in/vceratti_ | _Skype: ceratti_

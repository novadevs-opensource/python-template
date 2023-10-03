# Skeleton for a Python - Flask app using PostgreSQL optionally

1. Copy the template `docker/local/.env.example` to `docker/local/.env.`.
2. Set the variables as you wish. Below you have an example:

    ~~~sh
    # Project configuration
    COMPOSE_PROJECT_NAME=python-flask-template

    # Make settings
    DEFAULT_DIR=src
    SRC_BUILD=true
    FLASK_BUILD=true
    POSTGRESQL_BUILD=true

    # Docker
    DOCKER_SRC_DIR='src'  ## Options are: 'src' or '.'. The options depends on 'SRC_BUILD' parameter.
    DOCKER_NETWORK_NAME=local
    DOCKER_NETWORK_CIDR=192.17.210.0/24
    DOCKER_VOLUME_DB=db-data

    # Flask application
    FLASK_DOCKERFILE='./docker/local/python-flask/Dockerfile'
    FLASK_CONTAINER_NAME=flask
    FLASK_BASE_IMAGE=python:3.11
    FLASK_IMAGE_NAME="novadevs/${COMPOSE_PROJECT_NAME}-${FLASK_CONTAINER_NAME}:latest"
    FLASK_EXTERNAL_PORT=5000
    FLASK_INTERNAL_PORT=5000

    # PostgreSQL database
    POSTGRES_CONTAINER_NAME=postgres
    POSTGRES_BASE_IMAGE=postgres:15.4-bullseye
    POSTGRES_IMAGE_NAME="novadevs/${COMPOSE_PROJECT_NAME}-${POSTGRES_CONTAINER_NAME}:latest"
    POSTGRES_DATABASE=db_novadevs
    POSTGRES_USER=dba_novadevs
    POSTGRES_PASSWORD=Dba_2023  ## The password cannot contain special characters, otherwise, the 'connect-db' will not work
    POSTGRES_EXTERNAL_PORT=56432
    POSTGRES_INTERNAL_PORT=5432
    ~~~

    About the '**Make settings**' variables:
    - **DEFAULT_DIR**: *Do no touch this value*. The name of the default folder where the code is located, by default is `src`. This variable is used in the `build-structure` argument of `make` command to create the initial directory structure of the project.
    - **SRC_BUILD_**: Checks if the project will have a src folder. If it is set to `false`, the variable `DOCKER_SRC_DIR` must change to `.`.
    - **POSTGRESQL_BUILD_**: Checks if the project will use PostgreSQL or not.
    - **FLASK_BUILD_**: Checks if the project will use Flask or Python.

3. Run `make` command to see the options you have available.
4. Run `make -s build-structure` to configure the directory structure of the project. **NOTE:** This command must be run initially and just once.
5. Run `make -s build` to build the project from scratch.

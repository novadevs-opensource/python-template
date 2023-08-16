# Skeleton for a Python - Flask app using PostgreSQL

1. Copy the template `docker/local/.env.example` to `docker/local/.env.`.
2. Set the variables as you wish.
    1. Example of `docker/local/.env`
    ~~~sh
    # General
    COMPOSE_PROJECT_NAME=python-flask-template
    DOCKER_VOLUME_DB=db-data

    # Python
    PYTHON_IMAGE=python:3.9
    PYTHON_CONTAINER_NAME=flask

    # Flask
    FLASK_EXTERNAL_PORT=5000
    FLASK_INTERNAL_PORT=5000

    # PostgreSQL
    POSTGRESQL_IMAGE=postgres:latest
    POSTGRESQL_CONTAINER_NAME=db
    POSTGRESQL_EXTERNAL_PORT=5432
    POSTGRESQL_INTERNAL_PORT=5432
    POSTGRESQL_DATABASE=mydatabase
    POSTGRESQL_USER=myuser
    POSTGRESQL_PASSWORD=mypasswd
    ~~~

3. Copy the template `./.env.example` to `./.env`
    1. Set the variables as you wish.
    Example of `./.env`
    ~~~sh
    DEFAULT_DIR_=src
    SRC_BUILD_=true
    POSTGRESQL_BUILD_=true
    # IF FALSE => USE PYTHON INSTEAD
    FLASK_BUILD_=true
    ~~~
    2. This variables cannot have extra spaces at the end or they may have a conflict when executing the makefile
    3. Variables:
        - **DEFAULT_DIR_**: Name of the default folder for your project. It must be the same as the one in the root folder of the project. Example `src`
        - **SRC_BUILD_**: Checks if the project will have a src folder
        - **POSTGRESQL_BUILD_**: Checks if the project will use PostgreSQL or not
        - **FLASK_BUILD_**: Checks if the project will use Flask or Python


4. Run `make` command to see the options you have available.
5. Run `make build` to build the project from scratch

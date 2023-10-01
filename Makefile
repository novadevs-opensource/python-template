# Variables
DOCKER_DIR := docker/local
include /.$(PWD)/$(DOCKER_DIR)/.env
DEFAULT_DIR := src
SRC_BUILD := true
POSTGRESQL_BUILD = true # Don't touch for now
DOCKER_COMPOSE = docker-compose -f $(DOCKER_DIR)/docker-compose.yaml
DOCKER_COMPOSE_DB = docker-compose -f $(DOCKER_DIR)/docker-compose-db.yaml

##
## General functions
##

## Global configuration
.DELETE_ON_ERROR:

help:
	@echo '																									'
	@echo 'Makefile for generating basic skeleton for Python - Flask app									'
	@echo '																									'
	@echo 'Usage:																							'
	@echo '   make					Print the help															'
	@echo '   make help				Print the help															'
	@echo '   make build-requirements		Check if the requirements are fulfilled							'
	@echo '   make build-structure			Creates the Flask structure										'
	@echo '   make build				Build the environment from scratch									'
	@echo '   make urls				Print the application URL												'
	@echo '   make start				Start the application												'
	@echo '   make stop                    	Stop the application											'
	@echo '   make status                  	Display the status of the container								'
	@echo '   make destroy				Remove the whole environment										'
	@echo '   make build-with-db			Build the environment from scratch including Postgres			'
	@echo '   make urls-with-db			Print the application URLs including Postgres						'
	@echo '   make start-with-db			Start the application including Postgres						'
	@echo '   make stop-with-db     	        Stop the application including Postgres						'
	@echo '   make status-with-db       	    	Display the status of the containers					'
	@echo '   make destroy-with-db			Remove the whole environment including Postgres					'
	@echo '   make ssh				Connect to the Flask container											'
	@echo '   make ssh-db				Connect to the Postgres container									'
	@echo '   make connect-db			Connect to the Postgres database locally using psql command			'
	@echo '																									'

build-requirements:

	@echo ""
	@echo "build-requirements... Running..."

ifeq (,$(wildcard $(DOCKER_DIR)/.env))
	@echo ''
	@echo 'The configuration file "$(DOCKER_DIR)/.env" does not exist. Please, create it.'
	@exit 1
else
	@echo "build-requirements... OK..."
endif

build-structure:

	@echo "build-structure... Running..."

ifeq ($(SRC_BUILD),false)
	@if [ -z "$(wildcard $(DEFAULT_DIR)/*)" ]; then \
		echo "The directory '$(DEFAULT_DIR)' is empty, so there is nothing to copy."; \
		exit 1; \
	fi

	@mv $(DEFAULT_DIR)/* .
	@rmdir $(DEFAULT_DIR)/
else
	@echo "build-structure... Nothing to do..."
endif


##
## Flask without PostgreSQL functions
##

build:

	@echo "Building the project..."

	@$(MAKE) build-requirements
	@echo ''

	@$(MAKE) build-structure
	@echo ''

	@${DOCKER_COMPOSE} build --no-cache

	@echo ''
	@echo "Building... OK..."

urls:
	@echo ''
	@echo 'The flask server is running in the URL:'
	@echo '   http://localhost:$(FLASK_EXTERNAL_PORT)'
	@echo ''

start:

	@echo "Starting the project...."

	@${DOCKER_COMPOSE} up -d

	@$(MAKE) urls

stop:

	@echo "Stopping the project..."

	@${DOCKER_COMPOSE} stop

	@echo ''
	@echo "Stopping... OK..."

status:

	@echo "Displaying the status of the containers..."

	@${DOCKER_COMPOSE} ps

destroy:

	@echo "Cleaning the project..."

	@${DOCKER_COMPOSE} down -v -t 20

	@echo ''
	@echo "Cleaning... OK..."

ssh:

	@echo "ssh... Running..."

	@docker exec -u root -it $(COMPOSE_PROJECT_NAME)_$(FLASK_CONTAINER_NAME) bash


##
## Flask with PostgreSQL functions
##

build-with-db:

	@echo "Building the project with PostgreSQL..."

	@$(MAKE) build-requirements
	@echo ''

	@$(MAKE) build-structure
	@echo ''

	@${DOCKER_COMPOSE_DB} build --no-cache

	@echo ''
	@echo "Building... OK..."

urls-with-db:
	@echo ''
	@echo 'The flask server is running in the URL:'
	@echo '   http://localhost:$(FLASK_EXTERNAL_PORT)'
	@echo ''
	@echo 'The PostgreSQL server is running in the URL:'
	@echo '   http://localhost:$(POSTGRES_EXTERNAL_PORT)'

start-with-db:

	@echo "Starting the project...."

	@${DOCKER_COMPOSE_DB} up -d

	@$(MAKE) urls-with-db

stop-with-db:

	@echo "Stopping the project..."

	@${DOCKER_COMPOSE_DB} stop

	@echo ''
	@echo "Stopping... OK..."

status-with-db:

	@echo "Displaying the status of the containers..."

	@${DOCKER_COMPOSE_DB} ps

destroy-with-db:

	@echo "Cleaning the project..."

	@${DOCKER_COMPOSE_DB} down -v -t 20

	@echo ''
	@echo "Cleaning... OK..."

ssh-db:

	@echo "ssh-sql... Running..."

	@docker exec -u root -it $(COMPOSE_PROJECT_NAME)_$(POSTGRES_CONTAINER_NAME) bash

connect-db:

	@echo "Connecting to the PostgreSQL..."

	@psql postgresql://${POSTGRES_USER}:${POSTGRES_PASSWORD}@localhost:${POSTGRES_EXTERNAL_PORT}/${POSTGRES_DATABASE}

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
	@echo ''
	@echo 'Makefile for generating basic skeleton for Python - Flask app'
	@echo ''
	@echo 'Usage:							'
	@echo '   make							'
	@echo '   make build-requirements		'
	@echo '   make build-structure			'
	@echo '   make build					'
	@echo '   make urls						'
	@echo '   make up						'
	@echo '   make down						'
	@echo '   make clean					'
	@echo '   make build-with-sql			'
	@echo '   make up-with-sql				'
	@echo '   make down-with-sql			'
	@echo '   make clean-with-sql			'
	@echo '   make ssh						'
	@echo '   make ssh-sql					'
	@echo '   make help						'
	@echo ''

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

urls:
	@echo ''
	@echo 'The flask server is running in the URL:'
	@echo '   http://localhost:$(FLASK_EXTERNAL_PORT)'
	@echo ''

ssh:

	@echo "ssh... Running..."

	@docker exec -u root -it $(COMPOSE_PROJECT_NAME)_$(FLASK_CONTAINER_NAME) bash

ssh-sql:

	@echo "ssh-sql... Running..."

	@docker exec -u root -it $(POSTGRESQL_CONTAINER_NAME) bash

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

up:

	@echo "Starting the project...."

	@${DOCKER_COMPOSE} up -d

	@$(MAKE) urls

stop:

	@echo "Stopping the project..."

	@${DOCKER_COMPOSE} stop

clean:

	@echo "Cleaning the project..."

	@${DOCKER_COMPOSE} down -v -t 20

	@echo ''
	@echo "Cleaning... OK..."


##
## Flask with PostgreSQL functions
##

build-with-sql:

	@echo "build-with-sql... Running..."

	@$(MAKE) build-requirements
	@echo ""

ifeq ($(SRC_BUILD),true)
	@echo "build-with-sql... Build with $(DEFAULT_DIR) directory..."
	@${DOCKER_COMPOSE} build --build-arg SRC=src --no-cache
else
	@echo "build-with-sql... Build without $(DEFAULT_DIR) directory..."
	@${DOCKER_COMPOSE} build --build-arg SRC=. --no-cache
endif

	@echo "build-with-sql... OK..."

up-with-sql:

	@echo "up-with-sql... Running..."

	@${DOCKER_COMPOSE} up -d

	@echo "up-with-sql... OK..."

stop-with-sql:

	@echo "stop-with-sql... Running..."

	@${DOCKER_COMPOSE} stop

	@echo "stop-with-sql... OK..."

clean-with-sql:

	@echo "clean-with-sql... Running..."

	@${DOCKER_COMPOSE} down -v -t 20

	@echo "clean-with-sql... OK..."

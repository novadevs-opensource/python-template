# Variables
DOCKER_DIR := docker/local
include /.$(PWD)/$(DOCKER_DIR)/.env
DEFAULT_DIR := src
SRC_BUILD := true
POSTGRESQL_BUILD = true # Don't touch for now
DOCKER_COMPOSE = docker-compose -f $(DOCKER_DIR)/docker-compose.yaml
DOCKER_COMPOSE_NO_POSTGRESQL = docker-compose -f $(DOCKER_DIR)/docker-compose-no-postgresql.yaml

##
## General functions
##

## Global configuration
.DELETE_ON_ERROR:

help:
	@echo ''
	@echo 'Makefile for generating basic skeleton for python - flask app'
	@echo ''
	@echo 'Usage:'
	@echo '   make							'
	@echo '   make build-requirements		'
	@echo '   make build-structure			'
	@echo '   make build-with-sql			'
	@echo '   make up-with-sql				'
	@echo '   make down-with-sql			'
	@echo '   make clean-with-sql			'
	@echo '   make build-without-sql		'
	@echo '   make up-without-sql			'
	@echo '   make down-without-sql			'
	@echo '   make clean-without-sql		'
	@echo '   make urls						'
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

	@docker exec -u root -it $(FLASK_CONTAINER_NAME) bash

ssh-sql:

	@echo "ssh-sql... Running..."

	@docker exec -u root -it $(POSTGRESQL_CONTAINER_NAME) bash

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


##
## Flask without PostgreSQL functions
##

build-without-sql:

	@echo "build-without-sql... Running..."

	@$(MAKE) build-requirements
	@echo ""

ifeq ($(SRC_BUILD),true)
	@echo "build-with-sql... Build with $(DEFAULT_DIR) directory..."
	@${DOCKER_COMPOSE_NO_POSTGRESQL} build --build-arg SRC=app --no-cache
else
	@echo "build-with-sql... Build without $(DEFAULT_DIR) directory..."
	@${DOCKER_COMPOSE_NO_POSTGRESQL} build --build-arg SRC=. --no-cache
endif

	@echo "build-with-sql... OK..."

up-without-sql:

	@echo "up-with-sql... Running..."

	@${DOCKER_COMPOSE_NO_POSTGRESQL} up -d

	@echo "up-with-sql... OK..."


stop-without-sql:

	@echo "stop-without-sql... Running..."

	@${DOCKER_COMPOSE_NO_POSTGRESQL} stop

	@echo "stop-without-sql... OK..."

clean-without-sql:

	@echo "clean-without-sql... Running..."

	@${DOCKER_COMPOSE_NO_POSTGRESQL} down -v -t 20

	@echo "clean-without-sql... OK..."

# Load environment variables from .env file
include .env
# Variables
DOCKER_DIR := docker/local
include /.$(PWD)/$(DOCKER_DIR)/.env

DEFAULT_DIR := $(DEFAULT_DIR_)
SRC_BUILD := $(SRC_BUILD_)
FLASK_BUILD = $(FLASK_BUILD_)
POSTGRESQL_BUILD = $(POSTGRESQL_BUILD_)

DOCKER_COMPOSE = docker-compose -f $(DOCKER_DIR)/docker-compose.yaml
DOCKER_COMPOSE_NO_POSTGRESQL = docker-compose -f $(DOCKER_DIR)/docker-compose-no-postgresql.yaml

##
## General functions
##

## Global configuration
.DELETE_ON_ERROR:

foo:
	@echo 'envs "$(DEFAULT_DIR)" "$(SRC_BUILD)" "$(FLASK_BUILD)" "$(POSTGRESQL_BUILD)"'

help:
	@echo ''
	@echo 'Makefile for generating basic skeleton for Python / Flask with PostgreSQL option app'
	@echo ''
	@echo 'Usage:'
	@echo '   make										'	# displays the help
	@echo '   make build-requirements					'	# checks for the docker/local/.env
	@echo '   make build-structure						'	# controls the src folder ( if it exists or not )
	
	@echo '   make build-with-sql						'	# python / flask with db
	@echo '   make up-with-sql					'	# python / flask with db
	@echo '   make stop-with-sql				'	# python / flask with db
	@echo '   make clean-with-sql				'	# python / flask with db
	
	@echo '   make build-without-sql			'	# python / flask without db
	@echo '   make up-without-sql			'	# python / flask without db
	@echo '   make stop-without-sql			'	# python / flask without db
	@echo '   make clean-without-sql			'	# python / flask without db

	@echo '   make urls									'	# urls of the flask app
	@echo '   make ssh									'
	@echo '   make ssh-sql								'
	@echo '   make help									'	# help
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
	@echo "build-structure..."
	@if [ -f ./config.py ]; then rm ./config.py; fi
	@cp $(DEFAULT_DIR)/config.py .
# @rm $(DEFAULT_DIR)/config.py
endif


urls:
	@echo ''
	@echo 'The flask server is running in the URL:'
	@echo '   http://localhost:$(FLASK_EXTERNAL_PORT)'
	@echo ''


ssh:
	@echo "ssh... Running..."

	@docker exec -u root -it $(PYTHON_CONTAINER_NAME) bash


ssh-sql:
	@echo "ssh-sql... Running..."

	@docker exec -u root -it $(POSTGRESQL_CONTAINER_NAME) bash


##
## Python/Flask with PostgreSQL functions
##

build-with-sql:
	@echo "build-with-sql... Running..."

ifeq ($(SRC_BUILD),true)
	@echo "build-with-sql... Build with $(DEFAULT_DIR) directory..."
	@${DOCKER_COMPOSE} build --build-arg SRC=$(DEFAULT_DIR) --build-arg FLASK_BUILD=$(FLASK_BUILD) --no-cache
else
	@echo "build-with-sql... Build without $(DEFAULT_DIR) directory..."
	@${DOCKER_COMPOSE} build --build-arg SRC=. --build-arg FLASK_BUILD=$(FLASK_BUILD) --no-cache
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
## Python/Flask without PostgreSQL functions
##

build-without-sql:
	@echo "build-without-sql... Running..."

ifeq ($(SRC_BUILD),true)
	@echo "build-without-sql... Build with $(DEFAULT_DIR) directory..."
	@${DOCKER_COMPOSE_NO_POSTGRESQL} build --build-arg SRC=$(DEFAULT_DIR) --build-arg FLASK_BUILD=$(FLASK_BUILD) --no-cache
else
	@echo "build-without-sql... Build without $(DEFAULT_DIR) directory..."
	@${DOCKER_COMPOSE_NO_POSTGRESQL} build --build-arg SRC=. --build-arg FLASK_BUILD=$(FLASK_BUILD) --no-cache
endif

	@echo "build-without-sql... OK..."


up-without-sql:
	@echo "up-without-sql... Running..."

	@${DOCKER_COMPOSE_NO_POSTGRESQL} up -d

	@echo "up-without-sql... OK..."


stop-without-sql:
	@echo "stop-without-sql... Running..."

	@${DOCKER_COMPOSE_NO_POSTGRESQL} stop

	@echo "stop-without-sql... OK..."


clean-without-sql:
	@echo "clean-without-sql... Running..."

	@${DOCKER_COMPOSE_NO_POSTGRESQL} down -v -t 20

	@echo "clean-without-sql... OK..."

##
## Python/Flask without PostgreSQL functions
##

build: 
	@echo "build... Running..."
	@echo ""

	@$(MAKE) build-requirements
	@echo ""

	@$(MAKE) build-structure
	@echo ""


ifeq ($(POSTGRESQL_BUILD),true)
	@echo "build-with-postgresql..."
	$(MAKE) build-with-sql
else
	@echo "build-without-postgresql..."
	$(MAKE) build-without-sql
endif
	@echo ""


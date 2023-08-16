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


## Global configuration
.DELETE_ON_ERROR:

help:
	@echo ''
	@echo 'Makefile for generating basic skeleton for Python / Flask app with PostgreSQL option'
	@echo ''
	@echo 'Usage:'
	@echo '   make										'	# displays the help
	
	@echo '   make build								'	# build the environment
	@echo '   make up									'	# start the environment
	@echo '   make stop									'	# stop the environment
	@echo '   make clean								'	# clean the environment
	@echo ''

	@echo '   if using flask							'
	@echo '   make urls									'	# urls of the flask app
	@echo '   make ssh									'	# connect to the flask container
	@echo ''

	@echo '   if using postgresql						'
	@echo '   make ssh-sql								'	# connect to the postgresql
	@echo ''
	
	@echo '   make help									'	# help
	@echo ''


.build-structure:
	@echo "build-structure... Running..."

ifeq ($(SRC_BUILD),false)
	@if [ -z "$(wildcard $(DEFAULT_DIR)/*)" ]; then \
		echo "The directory '$(DEFAULT_DIR)' is empty, so there is nothing to copy."; \
		exit 1; \
	fi

ifeq ($(FLASK_BUILD),true)
	@if [ -f $(DEFAULT_DIR)/file.py ]; then rm $(DEFAULT_DIR)/file.py; fi
else
	@if [ -f $(DEFAULT_DIR)/__init__.py ]; then rm $(DEFAULT_DIR)/__init__.py; fi
	@mv $(DEFAULT_DIR)/file.py $(DEFAULT_DIR)/__init__.py
endif

	@mv $(DEFAULT_DIR)/* .
	@rmdir $(DEFAULT_DIR)/
else

ifeq ($(FLASK_BUILD),true)
	@if [ -f $(DEFAULT_DIR)/file.py ]; then rm $(DEFAULT_DIR)/file.py; fi
else
	@if [ -f $(DEFAULT_DIR)/__init__.py ]; then rm $(DEFAULT_DIR)/__init__.py; fi
	@mv $(DEFAULT_DIR)/file.py $(DEFAULT_DIR)/__init__.py
endif

	@if [ -f ./config.py ]; then rm ./config.py; fi
	@cp $(DEFAULT_DIR)/config.py .
# @rm $(DEFAULT_DIR)/config.py
endif


##
## Python/Flask without PostgreSQL functions
##

build: 
	@$(MAKE) clean

	@echo ""
	@echo "build... Running..."
	@echo ""

	@$(MAKE) .build-structure
	@echo ""


ifeq ($(POSTGRESQL_BUILD),true)
	@echo "build-with-postgresql..."
	@$(MAKE) -f build/makefile_postgresql build-with-sql
else
	@echo "build-without-postgresql..."
	@$(MAKE) -f build/makefile_no_postgresql build-without-sql
endif

	@echo ""
	@echo "----------------------------"
	@$(MAKE) up

	@echo "----------------------------"
	@$(MAKE) urls
	@echo ""


up:
	@echo "Starting the environment..."
	@echo ""

ifeq ($(POSTGRESQL_BUILD),true)
	@$(MAKE) -f build/makefile_postgresql up-with-sql
else
	@$(MAKE) -f build/makefile_no_postgresql up-without-sql
endif
	@echo ""


stop:
	@echo "Stopping the environment..."
	@echo ""

ifeq ($(POSTGRESQL_BUILD),true)
	@$(MAKE) -f build/makefile_postgresql stop-with-sql
else
	@$(MAKE) -f build/makefile_no_postgresql stop-without-sql
endif
	@echo ""


clean:
	@echo ""
	@echo "Cleaning the environment..."

ifeq ($(POSTGRESQL_BUILD),true)
	@$(MAKE) -f build/makefile_postgresql clean-with-sql
else
	@$(MAKE) -f build/makefile_no_postgresql clean-without-sql
endif
	@echo ""


urls:
	@echo ''
	@echo 'The flask server is running in the URL:'
	@echo '   http://localhost:$(FLASK_EXTERNAL_PORT)'
	@echo ''


ssh:
	@echo "ssh... Running..."
	@echo ""
	@docker exec -u root -it $(PYTHON_CONTAINER_NAME) bash


ssh-sql:
	@echo "ssh-sql... Running..."
	@echo ""
	@docker exec -u root -it $(POSTGRESQL_CONTAINER_NAME) bash



.PHONY: build up stop clean ssh ssh-sql urls
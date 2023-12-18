##
## Variables
##

PROJ_ENV = local
DOCKER_DIR := docker/local
include $(DOCKER_DIR)/.env
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
	@echo '   make load-vars			Import the variables												'
	@echo '   make build-structure			Creates the directory structure									'
	@echo '   make build				Build the environment from scratch									'
	@echo '   make urls				Print the application URLs												'
	@echo '   make start				Start the application												'
	@echo '   make stop                    	Stop the application											'
	@echo '   make status                  	Display the status of the containers							'
	@echo '   make destroy				Delete the environment												'
	@echo '   make logs				Display logs for the Python container									'
	@echo '   make logs-db				Display logs for the Postgres container								'
	@echo '   make ssh				Connect to the Python container											'
	@echo '   make ssh-db				Connect to the Postgres container									'
	@echo '   make connect-db			Connect to the Postgres database locally using psql command			'
	@echo '   make requirements			Install packages from the requirements.txt file						'
	@echo '   make sonarqube-analysis		Run Sonarqube analysis      									'
	@echo '   make sonarqube-check			Check the status of the project                   				'
	@echo '																									'


# This functions creates the directory structure
# NOTE: This functions MUST be run just once
build-structure:
	@echo "build-structure... Running..."

# Prepare the project for Flask or just Python
ifeq ($(PYTHON_BUILD),true)
	@mv $(DEFAULT_DIR)/file.py $(DEFAULT_DIR)/__init__.py
else
	@rm $(DEFAULT_DIR)/file.py
endif

# Prepare the project directory structure
ifeq ($(SRC_BUILD),false)
	@if [ -z "$(wildcard $(DEFAULT_DIR)/*)" ]; then \
		echo "The directory '$(DEFAULT_DIR)' is empty, so there is nothing to copy."; \
		exit 1; \
	fi

	@mv $(DEFAULT_DIR)/* .
	@rmdir $(DEFAULT_DIR)/
endif


build:
ifeq ($(POSTGRESQL_BUILD),true)
	@$(MAKE) -f build/makefile_postgresql build
else
	@$(MAKE) -f build/makefile_no_postgresql build
endif


urls:
ifeq ($(POSTGRESQL_BUILD),true)
	@$(MAKE) -f build/makefile_postgresql urls
else
	@$(MAKE) -f build/makefile_no_postgresql urls
endif


start:
ifeq ($(POSTGRESQL_BUILD),true)
	@$(MAKE) -f build/makefile_postgresql start
else
	@$(MAKE) -f build/makefile_no_postgresql start
endif


stop:
ifeq ($(POSTGRESQL_BUILD),true)
	@$(MAKE) -f build/makefile_postgresql stop
else
	@$(MAKE) -f build/makefile_no_postgresql stop
endif


status:
ifeq ($(POSTGRESQL_BUILD),true)
	@$(MAKE) -f build/makefile_postgresql status
else
	@$(MAKE) -f build/makefile_no_postgresql status
endif


destroy:
ifeq ($(POSTGRESQL_BUILD),true)
	@$(MAKE) -f build/makefile_postgresql destroy
else
	@$(MAKE) -f build/makefile_no_postgresql destroy
endif


ssh:
ifeq ($(POSTGRESQL_BUILD),true)
	@$(MAKE) -f build/makefile_postgresql ssh
else
	@$(MAKE) -f build/makefile_no_postgresql ssh
endif


ssh-db:
ifeq ($(POSTGRESQL_BUILD),true)
	@$(MAKE) -f build/makefile_postgresql ssh-db
else
	@echo "You are not using Postgres..."
endif


connect-db:
ifeq ($(POSTGRESQL_BUILD),true)
	@$(MAKE) -f build/makefile_postgresql connect-db
else
	@echo "You are not using Postgres..."
endif


logs:
ifeq ($(POSTGRESQL_BUILD),true)
	@$(MAKE) -f build/makefile_postgresql logs
else
	@$(MAKE) -f build/makefile_no_postgresql logs
endif


logs-db:
ifeq ($(POSTGRESQL_BUILD),true)
	@$(MAKE) -f build/makefile_no_postgresql logs-db
else
	@echo "You are not using Postgres..."
endif


requirements:
ifeq ($(POSTGRESQL_BUILD),true)
	@$(MAKE) -f build/makefile_postgresql requirements
else
	@$(MAKE) -f build/makefile_no_postgresql requirements
endif


sonarqube-setup:
ifeq ($(POSTGRESQL_BUILD),true)
	@$(MAKE) -f build/makefile_postgresql sonarqube-setup
else
	@$(MAKE) -f build/makefile_no_postgresql sonarqube-setup
endif


sonarqube-analysis:
ifeq ($(POSTGRESQL_BUILD),true)
	@$(MAKE) -f build/makefile_postgresql sonarqube-analysis
else
	@$(MAKE) -f build/makefile_no_postgresql sonarqube-analysis
endif


sonarqube-check:
ifeq ($(POSTGRESQL_BUILD),true)
	@$(MAKE) -f build/makefile_postgresql sonarqube-check
else
	@$(MAKE) -f build/makefile_no_postgresql sonarqube-check
endif


.PHONY: help build-structure build urls start stop status destroy logs logs-db ssh ssh-db connect-db requirements sonarqube-setup sonarqube-analysis sonarqube-check

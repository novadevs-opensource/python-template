##
## Variables
##

# For Docker
DOCKER_DIR := docker/local
DOCKER_COMPOSE = docker-compose -f $(DOCKER_DIR)/docker-compose.yaml
DOCKER_COMPOSE_DB = docker-compose -f $(DOCKER_DIR)/docker-compose-db.yaml


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
	@echo '   make urls				Print the application URL												'
	@echo '   make start				Start the application												'
	@echo '   make stop                    	Stop the application											'
	@echo '   make status                  	Display the status of the container								'
	@echo '   make destroy				Remove the whole environment										'
	@echo '   make ssh				Connect to the Python container											'
	@echo '   make ssh-db				Connect to the Postgres container									'
	@echo '   make logs				Display logs for the Python container										'
	@echo '   make logs-db				Display logs for the Postgres container									'
	@echo '   make connect-db			Connect to the Postgres database locally using psql command			'
	@echo '																									'

##
## Global functions
##

# This functions ensures that the env files exists before doing anything
load-vars:
ifeq (,$(wildcard $(DOCKER_DIR)/.env))
	@echo ''
	@echo 'The configuration file "$(DOCKER_DIR)/.env" does not exist. Please, create it.'
	@exit 1
else
# Load Docker variables
include $(DOCKER_DIR)/.env
endif

# This functions creates the directory structure
# NOTE: This functions must be run just once
build-structure:

	@$(MAKE) load-vars
	@echo ""

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


##
## Environment functions
##

build:
	@$(MAKE) destroy

	@echo ""
	@echo "Calling build..."
	@echo ""

ifeq ($(POSTGRESQL_BUILD),true)
	@$(MAKE) -f build/makefile_postgresql build
else
	@$(MAKE) -f build/makefile_no_postgresql build
endif

	@echo ""
	@echo "----------------------------"
	@$(MAKE) start

urls:
	@echo ""
	@echo "Calling urls..."

ifeq ($(POSTGRESQL_BUILD),true)
	@$(MAKE) -f build/makefile_postgresql urls
else
	@$(MAKE) -f build/makefile_no_postgresql urls
endif

start:
	@echo "Calling start..."

ifeq ($(POSTGRESQL_BUILD),true)
	@$(MAKE) -f build/makefile_postgresql start
else
	@$(MAKE) -f build/makefile_no_postgresql start
endif

stop:
	@echo "Calling stop..."

ifeq ($(POSTGRESQL_BUILD),true)
	@$(MAKE) -f build/makefile_postgresql stop
else
	@$(MAKE) -f build/makefile_no_postgresql stop
endif

status:
	@echo "Calling status..."

ifeq ($(POSTGRESQL_BUILD),true)
	@$(MAKE) -f build/makefile_postgresql status
else
	@$(MAKE) -f build/makefile_no_postgresql status
endif

destroy:
	@echo "Calling destroy..."

ifeq ($(POSTGRESQL_BUILD),true)
	@$(MAKE) -f build/makefile_postgresql destroy
else
	@$(MAKE) -f build/makefile_no_postgresql destroy
endif

ssh:
	@echo "Calling ssh..."

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

logs:
	@echo "Calling logs..."

ifeq ($(POSTGRESQL_BUILD),true)
	@$(MAKE) -f build/makefile_postgresql logs
else
	@$(MAKE) -f build/makefile_no_postgresql logs
endif

logs-db:
	@echo "Calling logs-db..."

ifeq ($(POSTGRESQL_BUILD),true)
	@$(MAKE) -f build/makefile_no_postgresql logs-db
else
	@echo "You are not using Postgres..."
endif

connect-db:

ifeq ($(POSTGRESQL_BUILD),true)
	@$(MAKE) -f build/makefile_postgresql connect-db
else
	@echo "You are not using Postgres..."
endif

.PHONY: load-vars build-structure build urls start stop status destroy ssh ssh-db logs logs-db connect-db

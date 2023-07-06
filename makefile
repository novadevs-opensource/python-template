# Variables
PROJ_ENV = local
include /.$(PWD)/docker/${PROJ_ENV}/.env
SRC_BUILD = true
POSTGRESQL_BUILD = true # Don't touch for now
DOCKER_COMPOSE = docker-compose -f ./docker/${PROJ_ENV}/docker-compose.yaml
DOCKER_COMPOSE_NO_POSTGRESQL = docker-compose -f ./docker/${PROJ_ENV}/docker-compose-no-postgresql.yaml
HTTP_PORT = $(HOST_PORT)


# Help
help:
	@echo ''
	@echo 'Makefile for generating basic skeleton for python - flask app'
	@echo ''
	@echo 'Usage:'
	@echo '   make						Print the help					    					'
	@echo '   make build				Create the project from scratch	  '
	@echo '   make up					Start the environment			    				'
	@echo '   make stop					Stop the environment			    			'
	@echo '   make urls					Print the flask url             		'
	@echo '   make help					Print the help					    				'
	@echo ''


build:
ifeq (,$(wildcard ./docker/local/.env))
	@echo ''
	@echo 'The configuration file "docker/local/.env" does not exist. Please, create it.'
	@exit 1
endif

	@echo 'Setting up the environment...'

	@if [ "$(SRC_BUILD)" = "true" ]; then \
		echo "Building with src option"; \
		echo "Creating folders src/ src/templates/ src/static/"; \
		mkdir -p src/templates src/static; \
		echo "__init__.py"; \
		echo "from flask import Flask" > src/__init__.py; \
		echo "" >> src/__init__.py; \
		echo "app = Flask(__name__)" >> src/__init__.py; \
		echo "" >> src/__init__.py; \
		echo "@app.route('/')" >> src/__init__.py; \
		echo "def index():" >> src/__init__.py; \
		echo "	return 'Hello, World!'" >> src/__init__.py; \
		echo "" >> src/__init__.py; \
		echo "if __name__ == '__main__':" >> src/__init__.py; \
		echo "	app.run(host='0.0.0.0', debug=True)" >> src/__init__.py; \
		echo "Creating more files"; \
		touch src/models.py; \
		touch src/templates/index.html src/static/main.css; \
	else \
		echo "Building without src option"; \
		echo "Creating folders templates/ static/"; \
		mkdir -p templates static; \
		echo "__init__.py"; \
		echo "from flask import Flask" > __init__.py; \
		echo "" >> __init__.py; \
		echo "app = Flask(__name__)" >> __init__.py; \
		echo "" >> __init__.py; \
		echo "@app.route('/')" >> __init__.py; \
		echo "def index():" >> __init__.py; \
		echo "	return 'Hello, World!'" >> __init__.py; \
		echo "" >> __init__.py; \
		echo "if __name__ == '__main__':" >> __init__.py; \
		echo "	app.run(host='0.0.0.0', debug=True)" >> __init__.py; \
		echo "Creating more files"; \
		touch models.py; \
		touch templates/index.html static/main.css; \
	fi

	$(MAKE) config

	@if [ "$(SRC_BUILD)" = "true" ]; then \
		echo "Building with SRC option"; \
		if [ "$(POSTGRESQL_BUILD)" = "true" ]; then \
			echo "Building with POSTGRESQL option"; \
			${DOCKER_COMPOSE} build --build-arg SRC=src --no-cache; \
		else \
			echo "Building without POSTGRESQL option"; \
			${DOCKER_COMPOSE_NO_POSTGRESQL} build --build-arg SRC=app --no-cache; \
		fi; \
	else \
		echo "Building without SRC option"; \
		if [ "$(POSTGRESQL_BUILD)" = "true" ]; then \
			echo "Building with POSTGRESQL option"; \
			${DOCKER_COMPOSE} build --build-arg SRC=. --no-cache; \
		else \
			echo "Building without POSTGRESQL option"; \
			${DOCKER_COMPOSE_NO_POSTGRESQL} build --build-arg SRC=. --no-cache; \
		fi; \
	fi
	
	$(MAKE) urls


config:
# config.py
	@echo "DEBUG = True" > config.py
	@echo "SECRET_KEY = 'your_secret_key_here'" >> config.py
	@echo "DATABASE_URI = 'your_database_uri_here'" >> config.py

up:
	@echo "\nStarting the environment..."
	@if [ "$(SRC_BUILD)" = "true" ]; then \
		echo "Running with SRC option"; \
		if [ "$(POSTGRESQL_BUILD)" = "true" ]; then \
			echo "Running with POSTGRESQL option"; \
			${DOCKER_COMPOSE} up -d; \
		else \
			echo "Running without POSTGRESQL option"; \
			${DOCKER_COMPOSE_NO_POSTGRESQL} up -d; \
		fi; \
	else \
		echo "Running without SRC option"; \
		if [ "$(POSTGRESQL_BUILD)" = "true" ]; then \
			echo "Running with POSTGRESQL option"; \
			${DOCKER_COMPOSE} up -d; \
		else \
			echo "Running without POSTGRESQL option"; \
			${DOCKER_COMPOSE_NO_POSTGRESQL} up -d; \
		fi; \
	fi
	@echo ""
	$(MAKE) urls

stop:
	@echo 'Stopping the environment...'
	@if [ "$(SRC_BUILD)" = "true" ]; then \
		echo "Stopping with SRC option"; \
		if [ "$(POSTGRESQL_BUILD)" = "true" ]; then \
			echo "Stopping with POSTGRESQL option"; \
			${DOCKER_COMPOSE} stop; \
		else \
			echo "Stopping without POSTGRESQL option"; \
			${DOCKER_COMPOSE_NO_POSTGRESQL} stop; \
		fi; \
	else \
		echo "Stopping without SRC option"; \
		if [ "$(POSTGRESQL_BUILD)" = "true" ]; then \
			echo "Stopping with POSTGRESQL option"; \
			${DOCKER_COMPOSE} stop; \
		else \
			echo "Stopping without POSTGRESQL option"; \
			${DOCKER_COMPOSE_NO_POSTGRESQL} stop; \
		fi; \
	fi
	@echo ""

clean:
	@if [ -d src ]; then rm -r src; fi
	@if [ -d static ]; then rm -r static; fi
	@if [ -d templates ]; then rm -r templates; fi
	@if [ -f config.py ]; then rm config.py; fi
	@if [ -f models.py ]; then rm models.py; fi
	@if [ -f __init__.py ]; then rm __init__.py; fi

urls:
	@echo ''
	@echo 'The flask server is running in the URL:'
	@echo '   http://localhost:$(HTTP_PORT)'
	@echo ''
sh:
	@docker exec -u root -it $(COMPOSE_PYTHON_PROJECT_NAME) bash
.PHONY: build up stop config help clean urls sh
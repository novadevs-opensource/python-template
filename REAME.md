# Skeleton for a Python - Flask app using PostgreSQL

1. Copy the template `docker/local/.env.example` to `docker/local/.env.`.
2. Set the variable as you wish.
3. Run `make` command to see the options you have available.



- [x] archivo env global que controle si el proyecto es solo python, python+db, flask, flask + db
- [x] el build-requirements en los build no hace falta porque ya lo hago yo en el global
- [ ] un make build que haga las cosas el solito
- [ ] un make up - stop - clean global
- [ ] hacer que se autorefresque el contenido
- [ ] bash scripts o makefiles propios para flask / postgresql
- [ ] revisar el sistema de archivos cuando es con python
- [ ] revisar los mensajes para informar si estamos usando flask/python/sql
- [ ] actualizar los envssss

- [ ] opciones:
	- [x] flask sql src
	- [x] flask sql !src
	- [ ] flask !sql src
	- [ ] flask !sql !src

	- [x] python sql src
	- [ ] python sql !src
	- [x] python !sql src
	- [ ] python !sql !src
- [ ] TODO -> testear `python sql src` && `python sql !src`
- [ ] hacer una qa 


## eliminar todo
~~~sh
docker stop $(docker ps -aq)
docker rm $(docker ps -aq)
~~~

## encontrar puerto ocupado
~~~sh
sudo lsof -i :5000
~~~

## kill process if docker-registry
~~~sh
sudo systemctl stop docker-registry
~~~

## comprobar si está flask instalado
~~~sh
docker run -it 'container-name' /bin/bash
pip list
~~~




help:
	@echo 'Usage:                                                                  '
	@echo '   make                         Print the help                          '
	@echo '   make build                   Build the environment from scratch      '
	@echo '   make up                      Start the environment                   '
	@echo '   make stop                    Stop the environment                    '
	@echo '   make status                  Display the containers status           '
	@echo '   make clean                   Clean the environment                   '
	@echo '   make cache                   Clean application cache                 '
	@echo '   make perm                    Set the permissions of the application  '
	@echo '   make update                  Update the application                  '
	@echo '   make nginx                   Connect to the nginx    container       '
	@echo '   make sh                      Connect to the php container            '
	@echo '   make db                      Connect to the database container       '
	@echo '   make tests                   Run the tests                           '
	@echo '   make clean-tests             Clean the environment and run the tests '
	@echo '   make urls                    Print the applications URLs             '
	@echo '   make help                    Print the help                          '


# Skeleton for a Python - Flask app using PostgreSQL

1. Copy the template `docker/local/.env.example` to `docker/local/.env.`.
2. Set the variable as you wish.
3. Run `make` command to see the options you have available.


- [ ] python							// hacer dockercompose con python solo y cambiar la estructura de archivos, o al menos la info
- [ ] python + pgsql			// lo de arriba + meterle postgresql
- [x] flask
- [x] flask + pgsql


- [x] archivo env global que controle si el proyecto es solo python, python+db, flask, flask + db
- [ ] un make build que haga las cosas el solito
- [x] el build-requirements en los build no hace falta porque ya lo hago yo en el global
- [ ] hacer que se autorefresque el contenido


## eliminar todo
docker stop $(docker ps -aq)
docker rm $(docker ps -aq)

## encontrar puerto ocupado
sudo lsof -i :5000

## kill process if docker-registry
sudo systemctl stop docker-registry



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


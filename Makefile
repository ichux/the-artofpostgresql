FORMAT="\nID\t{{.ID}}\nIMAGE\t{{.Image}}\nCOMMAND\t{{.Command}}\nCREATED\t{{.RunningFor}}\nSTATUS\t\
{{.Status}}\nPORTS\t{{.Ports}}\nNAMES\t{{.Names}}\n"

DB_CONNECTION = docker-compose run --rm database psql "postgresql://postgres@database:5432"

help:
	@echo "Please use \`make <target>\` where <target> is one of"
	@echo "  bash            to make bash for the docker environment"
	@echo "  logs            to make logs for the docker environment show up"
	@echo "  up              powers up docker"
	@echo "  down            to make the docker environment go down and clean itself up"
	@echo "  tail            to tail the artofpostgres container"
	@echo "  dpa             to run docker ps -a"
	@echo "  config          displays the docker configuration"
	@echo "  bootstrap       boostrap the artofpostgres container"

bash:
	docker exec -it artofpostgres bash

logs:
	docker-compose logs --timestamps --follow

up:
	docker-compose up --build -d

down:
	docker-compose down
	docker images; echo
	# docker rmi artofpostgresql_database; rm -rf postgresql/

tail:
	docker logs artofpostgres --timestamps --follow

dpa:
	docker-compose ps
	docker ps -a --format $(FORMAT)

config:
	docker-compose config

bootstrap: up
	$(DB_CONNECTION) -c 'CREATE DATABASE appdev;'
	$(DB_CONNECTION) -c 'CREATE EXTENSION IF NOT EXISTS btree_gist;'
	$(DB_CONNECTION) -c 'CREATE EXTENSION IF NOT EXISTS cube;'
	$(DB_CONNECTION) -c 'CREATE EXTENSION IF NOT EXISTS earthdistance;'
	$(DB_CONNECTION) -c 'CREATE EXTENSION IF NOT EXISTS hstore;'
	$(DB_CONNECTION) -c 'CREATE EXTENSION IF NOT EXISTS intarray;'
	$(DB_CONNECTION) -c 'CREATE EXTENSION IF NOT EXISTS pg_trgm;'
	$(DB_CONNECTION) -c 'CREATE EXTENSION IF NOT EXISTS ip4r;'
	$(DB_CONNECTION) -c 'CREATE EXTENSION IF NOT EXISTS hll;'
	$(DB_CONNECTION) -c '\dx'; echo
	cp appdev.dump postgresql/
	docker-compose run --rm database pg_restore -h database -U postgres -d appdev --if-exists --clean --verbose --no-owner ./appdev.dump

.PHONY: bootstrap up down dpa config tail logs bash
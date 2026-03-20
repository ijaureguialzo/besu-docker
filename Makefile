#!make

nodo=1

help: _header
	${info }
	@echo Opciones:
	@echo -----------------------
	@echo init
	@echo -----------------------
	@echo blockchain
	@echo -----------------------
	@echo direcciones
	@echo qbft_config
	@echo generar_config_besu
	@echo numerar_claves
	@echo generar_jwts
	@echo generar_accounts_allowlist
	@echo generar_nodes_allowlist
	@echo generar_static_nodes
	@echo -----------------------
	@echo mostrar_websocat [nodo=1]
	@echo -----------------------
	@echo build
	@echo workspace
	@echo start / stop / restart
	@echo -----------------------
	@echo clean
	@echo -----------------------

_header:
	@echo ----
	@echo Besu
	@echo ----

init:
	@poetry install

direcciones:
	@scripts/crear_direccion private/direcciones/direccion_1
	@scripts/crear_direccion private/direcciones/direccion_2
	@scripts/crear_direccion private/direcciones/direccion_3

qbft_config:
	@scripts/generar_qbft_config

generar_config_besu:
	@besu operator generate-blockchain-config --config-file=private/qbftConfigFile.json --to=private/networkFiles --private-key-file-name=key

blockchain: clean direcciones qbft_config generar_config_besu numerar_claves generar_jwts generar_accounts_allowlist generar_nodes_allowlist generar_static_nodes

numerar_claves:
	@scripts/numerar_claves

generar_jwts:
	@mkdir -p private/jwts
	@cd private/jwts && poetry run python ../../scripts/sortu_JWT.py 1
	@cd private/jwts && poetry run python ../../scripts/sortu_JWT.py 2

generar_accounts_allowlist:
	@scripts/generar_accounts_allowlist

generar_nodes_allowlist:
	@scripts/generar_nodes_allowlist

generar_static_nodes:
	@scripts/generar_static_nodes

mostrar_websocat:
	@scripts/mostrar_websocat $(nodo)

build:
	@docker compose build --pull

workspace:
	@docker compose run -q --service-ports --rm workspace /bin/bash

_urls: _header
	${info }
	@echo -----------------------------------------------------
	@echo [ethstats] http://localhost:3000
	@echo -----------------------------------------------------

_start-command:
	@docker-compose up -d --remove-orphans ethstats-server besu-node1 besu-node2

start: _start-command _urls

stop:
	@docker-compose down

restart: stop start

clean:
	@docker-compose down -v --remove-orphans
	@rm -rf private/* && touch private/.gitkeep

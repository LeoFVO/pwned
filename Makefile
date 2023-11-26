SHELL := /bin/bash

.PHONY: init

init: setup
	# Create necessary folders
	mkdir -p qwdata

setup:
	# Source .env file
	set -a && source .env && set +a

start: init
	docker compose up -d
	@echo "Quickwit is running on http://localhost:7280"
	@echo "Minio is running on http://localhost:9001"

stop:
	docker compose down

clean: stop
	rm -rf qwdata
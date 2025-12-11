PHONY: docker build

docker:
	@clear
	@date
	@docker-compose up			# The old way with docker-compose (v1)
	@docker compose up

build:
	@clear
	@date
	@mvn clean package

PHONY: docker build

docker:
	@clear
	@date
	@docker-compose up

build:
	@clear
	@date
	@mvn clean package

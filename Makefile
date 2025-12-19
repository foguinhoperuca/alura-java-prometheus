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

fix-docker:
	@sudo dmesg | grep -i apparmor | grep -i docker
	@sudo apt-get install apparmor-utils -y
	@sudo aa-disable /etc/apparmor.d/usr.sbin.mysqld # remove any profile that is not working
	@docker stop mysql-forum-api

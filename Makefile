setup-dbs:
	-eval "$(docker-machine env default)"
	@docker-compose build
	@docker-compose stop
	# @docker-compose rm -vf
	@docker-compose up -d zoo1 zoo2 zoo3

up: setup-dbs
	@env | grep DOCKER_HOST
	@echo '=== Sleeping for 8s while Zookeeper initialises ===' && sleep 8
	-docker-compose up
	@docker-compose stop

reset:
	@docker-compose stop
	@docker-compose rm -vf

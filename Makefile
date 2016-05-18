setup-zoo:
	-eval "$(docker-machine env default)"
	@docker-compose down -v
	@docker-compose build
	# @docker-compose rm -vf
	@docker-compose up -d zoo1 zoo2 zoo3

up: setup-zoo
	@echo '=== Sleeping for 8s while Zookeeper initialises ===' && sleep 8
	-docker-compose up
	@docker-compose down

reset:
	@docker-compose stop
	@docker-compose rm -vf

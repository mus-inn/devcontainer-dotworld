.DEFAULT_GOAL := help

# define the container name : container=container_name
container=##APP_NAME##

zsh: ## SSH into the container with zsh
	@docker exec -it $(container) su - root -c zsh
bash: ## SSH into the container with bash
	@docker exec -it $(container) su - root -c bash

.PHONY: help ## Show help message
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[1m\033[92m%-30s\033[0m %s\n", $$1, $$2}'

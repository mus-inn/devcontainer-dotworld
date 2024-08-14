.DEFAULT_GOAL := help

# define the container name : container=container_name
container=$(APP_NAME)

container-up: ## Start the container
	@devcontainer up --workspace-folder .

zsh: ## SSH into the container
	@docker exec -it $(container) su - vscode -c zsh
bash: ## SSH into the container
	@docker exec -it $(container) su - vscode -c bash

stan: ## Run phpstan, use 'baseline=1' to generate a baseline
ifdef baseline
	@docker exec -it $(container) sh -c "php ./vendor/bin/phpstan analyse --generate-baseline"
else
	@docker exec -it $(container) sh -c "php ./vendor/bin/phpstan analyse"
endif

test: ## Run unit-tests, 'filter=<needed>' to filter, 'path=<path_to_file>' for a specific test file, 'dirty=1' to run test with uncommiting changes, 'coverage=1' to run tests with coverage, 'profile=1' to run tests with profiling
ifdef coverage
	@docker exec -it $(container) sh -c "./vendor/bin/pest --coverage --testsuite Feature,Unit "
else ifdef dirty
	@docker exec -it $(container) sh -c "./vendor/bin/pest --dirty"
else ifdef filter
	@docker exec -it $(container) sh -c "./vendor/bin/pest --filter=$(filter)"
else ifdef path
	@docker exec -it $(container) sh -c "./vendor/bin/pest $(path)"
else ifdef profile
	@docker exec -it $(container) sh -c "./vendor/bin/pest --profile --testsuite Feature,Unit"
else
	@docker exec -it $(container) sh -c "./vendor/bin/pest --testsuite Feature,Unit"
endif

tinker: ## Run tinker
	@docker exec -it $(container) sh -c "php artisan tinker"

.PHONY: help ## Show help message
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[1m\033[92m%-30s\033[0m %s\n", $$1, $$2}'

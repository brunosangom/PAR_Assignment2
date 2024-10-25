SHELL := /bin/bash # Use bash syntax
GREEN  := $(shell tput -Txterm setaf 2)
YELLOW := $(shell tput -Txterm setaf 3)
RESET  := $(shell tput -Txterm sgr0)

.PHONY: all setup-env install-planutils install-singularity help

# all: setup-env install-planutils install-singularity

all: help


## Setup Python environment
setup-env: ## Create a Python virtual environment and install dependencies.
	@if [ ! -d "venv" ]; then \
		python3 -m venv venv; \
		echo "virtual environment created."; \
	else \
		echo "virtual environment already exists."; \
	fi
	@. venv/bin/activate; \
	pip install --upgrade pip; \
	if [ -f requirements.txt ]; then \
		echo "Installing packages from requirements.txt..."; \
		pip install -r requirements.txt; \
	fi

## Install Planutils
install-planutils: setup-env ## Install Planutils in the virtual environment. => REQUIRE: singularity-ce and apptainer
	@. venv/bin/activate; \
	echo "Installing Planutils..."; \
	pip install planutils; \
	planutils install -y optic downward delfi ff lama metric-ff dual-bfws-ffparser enhsp tfd
 

## Show help
help: ## Show this help.
	@echo ''
	@echo 'Usage:'
	@echo '  ${YELLOW}make${RESET} ${GREEN}<target>${RESET}'
	@echo ''
	@echo 'Targets:'
	@awk 'BEGIN {FS = ":.*?## "} { \
		if (/^[a-zA-Z_-]+:.*?##.*$$/) {printf "    ${YELLOW}%-30s${GREEN}%s${RESET}\n", $$1, $$2} \
		else if (/^## .*$$/) {printf "  ${GREEN}%s${RESET}\n", substr($$1,4)} \
		}' $(MAKEFILE_LIST)

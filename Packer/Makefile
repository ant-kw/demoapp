SHELL = /bin/bash


ENV = test
TMPLATE = database


GCP_PROJECT_ID := demoapp-${ENV}


.PHONY := help build-all build

.DEFAULT_GOAL = help

help:
	@echo -e "\nDefaults:\n Project: $(GCP_PROJECT_ID)\n Target Image: $(TMPLATE)"
	@echo -e "\n[!] You'll need to specify an action: \n"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo -e "\nExample: make ENV=test IMAGE=base build\n\n"


build: ## - Build an image
	@echo -e "[i] Building ${TMPLATE} in ${GCP_PROJECT_ID}..."
	@packer build -var 'GCP_PROJECT_ID=${GCP_PROJECT_ID}' -var 'ROLE=packer' -var 'ENV=${ENV}' ${TMPLATE}.pkr.hcl

init: ## - download plugins and setup packer environment
	@echo -e "[i] Packer Init"
	@packer init ${TMPLATE}.pkr.hcl

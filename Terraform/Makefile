SHELL = /bin/bash

.PHONY : help init plan apply destroy

## Defaults

ENV = test
TF_PREFIX = tf-state_$(ENV)
TF_PLANFILE = PLAN-$(ENV).TFPLAN

GCP_PROJECT_ID := demoapp-$(ENV)

export TF_IN_AUTOMATION = true


help:
	@echo -e "\n Help:\n"
	@echo -e "Targeting project: demoapp-$(ENV)\n"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo -e "\nExample: make ENV=test plan\n\n"


init: ## - Initialize local terraform environment
	@echo "[i] init for demoapp $(ENV) - $(GCP_PROJECT_ID)"
	@terraform init \
		-backend-config "bucket=demoapp-tf-state" \
		-backend-config "prefix=$(TF_PREFIX)" \
		-get=true \
		-var-file=env/$(ENV).tfvars \
		-var 'gcp_project_id=$(GCP_PROJECT_ID)'

plan: ## - Perform a terraform plan
	@echo "[i] Planning for demoapp $(ENV)"
	@terraform plan -var-file=env/$(ENV).tfvars -var 'gcp_project_id=$(GCP_PROJECT_ID)' -out=$(TF_PLANFILE)

apply: ## - Apply terraform changes from the plan
	@echo "[i] Applying to demoapp $(ENV)"
	@terraform apply $(TF_PLANFILE)
	@rm $(TF_PLANFILE)

clean: ## - Clean local terraform environment
	@echo "[i] Cleaning up working dir"
	@rm -Rf ./.terraform ./.terraform* *.TFPLAN *.tfstate

destroy: ## - Destroy env
	@echo "[!] Destroying in 5 seconds - Ctrl-C to stop! "
	@sleep 5
	@terraform plan -destroy -var-file=env/$(ENV).tfvars



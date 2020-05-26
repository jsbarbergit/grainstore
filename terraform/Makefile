TF=$(shell which terraform)

.PHONY: init
init: ## Run Terraform init in the terraform/ dir
	$(TF) init

.PHONY: format
format: ## Recursive Terraform format 
	$(TF) fmt -recursive

.PHONY: validate
validate: ## Validate Terrform in terraform/ dir
	$(MAKE) init && $(TF) validate

.PHONY: scan
scan: ## Scan for security issues
	$(MAKE) docker-login
	docker run --rm -it -v "$(pwd):/workdir" wesleydeanflexion/tfsec .

.PHONY: plan
plan: ## Run terraform plan
	$(MAKE) validate && $(MAKE) scan && $(TF) plan

.PHONY: auto-apply
auto-apply: ## Apply terraform changes without prompting
	$(MAKE) scan && $(TF) apply --auto-approve

.PHONY: all
all: ## Run  full terraform setup steps
	$(MAKE) validate && $(MAKE) auto-apply

.PHONY: docker-login
docker-login:
	docker login
TF=$(shell which terraform)
TFDIR="./terraform/"

.PHONY: init
init: ## Run Terraform init in the terraform/ dir
	$(MAKE) -C $(TFDIR) init

.PHONY: format
format: ## Recursive Terraform format 
	$(MAKE) -C $(TFDIR) format

.PHONY: validate
validate: ## Validate Terrform in terraform/ dir
	$(MAKE) -C $(TFDIR) validate

.PHONY: scan
scan: ## Scan Terrform in terraform/ dir for security issues
	$
	$(MAKE) -C $(TFDIR) scan

.PHONY: plan
plan: ## Scan Terrform in terraform/ dir for security issues
	$
	$(MAKE) -C $(TFDIR) plan

.PHONY: auto-apply
auto-apply: ## Apply terraform changes without prompting
	$(MAKE) -C $(TFDIR) auto-apply

.PHONY: all
all: ## Run full terraform setup
	$(MAKE) -C $(TFDIR) all
TFDIR="./terraform/"

.PHONY: explain
explain:
	#  ____           _           _                     __  __       _        
	# / ___|_ __ __ _(_)_ __  ___| |_ ___  _ __ ___    |  \/  | __ _| | _____ 
	#| |  _| '__/ _` | | '_ \/ __| __/ _ \| '__/ _ \   | |\/| |/ _` | |/ / _ |
	#| |_| | | | (_| | | | | \__ \ || (_) | | |  __/   | |  | | (_| |   <  __/
	# \____|_|  \__,_|_|_| |_|___/\__\___/|_|  \___|...|_|  |_|\__,_|_|\_\___|
	#                                                                         
	@cat Makefile* | grep -E '^[a-zA-Z_-]+:.*?## .*$$' | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
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

.PHONY: plan-dev 
plan-dev: ## Create a  Terrform Plan for the DEV environment
	$
	$(MAKE) -C $(TFDIR) plan-dev

.PHONY: apply-dev
apply-dev: ## Apply terraform changes to DEV environment without prompting
	$(MAKE) -C $(TFDIR) apply-dev

.PHONY: auto-apply-dev
auto-apply-dev: ## Apply terraform changes to DEV environment with confirmation prompts
	$(MAKE) -C $(TFDIR) auto-apply-dev

.PHONY: all-dev 
all-dev: ## Run full terraform setup for DEV environment
	$(MAKE) -C $(TFDIR) all-dev

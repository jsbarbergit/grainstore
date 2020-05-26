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
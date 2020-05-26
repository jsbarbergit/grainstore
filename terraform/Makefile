TF=$(shell which terraform)

.PHONY: init
init:
	$(TF) init

.PHONY: format
format: ## Recursive Terraform format 
	$(TF) fmt -recursive

.PHONY: validate
validate:
	$(MAKE) init && $(TF) validate

.PHONY: scan
scan:
	$(MAKE) docker-login
	docker run --rm -it -v "$(pwd):/workdir" wesleydeanflexion/tfsec .

.PHONY: plan
plan:
	$(MAKE) validate && $(MAKE) scan && $(TF) plan

.PHONY: auto-apply
auto-apply:
	$(MAKE) scan && $(TF) apply --auto-approve

.PHONY: all
all:
	$(MAKE) validate && $(MAKE) auto-apply

.PHONY: docker-login
docker-login:
	docker login
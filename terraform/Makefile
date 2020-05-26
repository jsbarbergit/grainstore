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

.PHONY: plan-dev
plan-dev:
	$(TF) workspace select dev && $(MAKE) validate && $(MAKE) scan && $(TF) plan -var-file=tfvars/dev/vars.tfvars

.PHONY: apply-dev
apply-dev:
	$(TF) workspace select dev && $(MAKE) scan && $(TF) apply -var-file=tfvars/dev/vars.tfvars

.PHONY: auto-apply-dev
auto-apply-dev:
	$(TF) workspace select dev && $(MAKE) scan && $(TF) apply --auto-approve -var-file=tfvars/dev/vars.tfvars

.PHONY: all-dev
all-dev:
	$(TF) workspace select dev && $(MAKE) validate && $(MAKE) auto-apply-dev

.PHONY: docker-login
docker-login:
	docker login
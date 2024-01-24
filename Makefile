TERRAFORM=terraform
PLAN_OUT=plan.out
LOG_FILE=terraform.log

plan: init validate format lint refresh
	$(TERRAFORM) plan -no-color -out=$(PLAN_OUT) | tee $(LOG_FILE)

apply:
	$(TERRAFORM) apply -no-color -auto-approve $(PLAN_OUT) | tee $(LOG_FILE)

destroy: refresh
	$(TERRAFORM) destroy -no-color -auto-approve | tee $(LOG_FILE)

re-create: destroy apply

init:
	$(TERRAFORM) init -backend=true | tee $(LOG_FILE)

validate:
	$(TERRAFORM) validate | tee $(LOG_FILE)

format:
	$(TERRAFORM) fmt -check -recursive | tee $(LOG_FILE)

lint:
	tflint --recursive | tee $(LOG_FILE)

refresh:
	$(TERRAFORM) refresh | tee $(LOG_FILE)

create-inventory:
	@echo "Retrieving Terraform configuration..."
	@terraform output -raw kubernetes_configuration | tr -d '"' > inventory.yaml
	@echo "Inventory file 'inventory.yaml' successfully created."

.PHONY: docs

docs:
	@echo "Generating documentation for main project..."
	@terraform-docs --config terraform-docs.yaml .
	@echo "Generating documentation for module..."
	@cd proxmox_vm_module && terraform-docs --config terraform-docs.yaml .
	@echo "Documentation generated successfully."
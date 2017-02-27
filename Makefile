TEMPLATE_FILE :=  "file://phaselist.template"
APPLICATION_NAME := "phaselist"
PARAMS_FILE := "file://params.json"

export AWS_DEFAULT_REGION := us-west-2

validate-template:
	aws cloudformation validate-template \
		--template-body $(TEMPLATE_FILE)

create-stack:
	aws cloudformation create-stack \
		--disable-rollback \
		--stack-name $(APPLICATION_NAME) \
		--tags '[ { "Key":"Application", "Value":$(APPLICATION_NAME) } ]' \
		--template-body $(TEMPLATE_FILE) \
		--parameters $(PARAMS_FILE) \
		--capabilities CAPABILITY_NAMED_IAM
	@echo "Waiting for stack creation to complete ..."
	aws cloudformation wait stack-create-complete --stack-name $(APPLICATION_NAME)

update-stack:
	aws cloudformation update-stack \
		--stack-name $(APPLICATION_NAME) \
		--tags '[ {  "Key":"Application", "Value":$(APPLICATION_NAME) } ]' \
		--template-body $(TEMPLATE_FILE) \
		--parameters $(PARAMS_FILE) \
		--capabilities CAPABILITY_NAMED_IAM
	@echo "Waiting for stack update to complete ..."
	aws cloudformation wait stack-update-complete --stack-name $(APPLICATION_NAME)

delete-stack:
	aws cloudformation delete-stack \
		--stack-name $(APPLICATION_NAME)
	@echo "Waiting for stack deletion to complete ..."
	aws cloudformation wait stack-delete-complete --stack-name $(APPLICATION_NAME)

publish-html:
	docker run --rm --name phaselist -t pkumaschow/phaselist > phaselist.html
	aws s3 cp public/default.css s3://phaselist
	aws s3 cp phaselist.html s3://phaselist	



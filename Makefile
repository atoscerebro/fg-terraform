CLOUD_PROVIDER := azure
TERRAFORM_SOURCES := $(shell find ${CLOUD_PROVIDER} -name "*.tf" -a -not -path "*/test/*")
MODULE_DIRECTORIES := $(shell find ${CLOUD_PROVIDER} -mindepth 1 -maxdepth 1 -type d)

# Usage: make list-modules CLOUD_PROVIDER=(aws|azure)
list-modules:
	@echo $(MODULE_DIRECTORIES) | sed s/[[:space:]]/,/g

# Usage: make (aws|azure)-docs CLOUD_PROVIDER=(aws|azure)
$(CLOUD_PROVIDER)-docs: $(TERRAFORM_SOURCES)
	echo $(MODULE_DIRECTORIES) | xargs -n 1 terraform-docs markdown table --output-file README.md
	openssl sha256 $(TERRAFORM_SOURCES) > $(CLOUD_PROVIDER)-docs

test-unit:
	go test ./... -short -count 1

test-integration:
	go test ./... -count 1
	
lint:
	tflint -f compact --recursive

release:
	gh workflow run release.yml

.PHONY: build-docs release lint test-unit test-integration
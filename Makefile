# Usage: make (aws|azure)-docs CLOUD_PROVIDER=(aws|azure)
MODULE_ROOTS := main
TERRAFORM_SOURCES := $(shell find ./${CLOUD_PROVIDER} -name "*.tf")

find-modules:
	find -E ${CLOUD_PROVIDER} -type f -regex '.*($(MODULE_ROOTS))\.tf$$' -exec dirname "{}" \; | uniq

build-docs:
	$(MAKE) -s find-modules | xargs -n 1 terraform-docs markdown table --output-file README.md

$(CLOUD_PROVIDER)-docs: $(TERRAFORM_SOURCES)
	$(MAKE) -s build-docs; openssl sha256 $(TERRAFORM_SOURCES) > $(CLOUD_PROVIDER)-docs

test-unit:
	go test ./... -short -count 1

test-integration:
	go test ./... -count 1
	
lint:
	tflint -f compact --recursive

release:
	gh workflow run release.yml

.PHONY: find-modules build-docs release lint test-unit test-integration
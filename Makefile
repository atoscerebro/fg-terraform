TERRAFORM_SOURCES := $(shell find modules -name "*.tf")
MODULE_SOURCES := $(shell find modules -type d)
MODULE_DIRECTORIES := $(shell find modules -mindepth 2 -type d)

module-docs: $(TERRAFORM_SOURCES)
	echo $(MODULE_DIRECTORIES) | xargs -n 1 terraform-docs markdown table --output-file README.md
	openssl sha256 $(TERRAFORM_SOURCES) > module-docs

root-docs: $(MODULE_SOURCES)
	bash ./scripts/build-root-docs.sh README.md
	openssl sha256 README.md > root-docs

build-docs: module-docs root-docs

test-docs:
	bash ./scripts/test-root-docs.sh test_README.md README.md

.PHONY: build-docs test-docs

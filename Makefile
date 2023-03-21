# Usage: make docs CLOUD_PROVIDER=(aws|azure)
MODULE_ROOTS := main
TERRAFORM_SOURCES := $(shell find ./${CLOUD_PROVIDER} -name "*.tf")

find-modules:
	find -E ${CLOUD_PROVIDER} -type f -regex '.*($(MODULE_ROOTS))\.tf$$' -exec dirname "{}" \; | uniq

build-docs:
	$(MAKE) -s find-modules | xargs -n 1 terraform-docs markdown table --output-file README.md

docs: $(TERRAFORM_SOURCES)
	$(MAKE) -s build-docs; openssl sha256 $(TERRAFORM_SOURCES) > docs

.PHONY: find-modules build-docs

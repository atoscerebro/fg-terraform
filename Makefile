MODULE_ROOTS := main|site
TERRAFORM_SOURCES := $(shell find ./modules -name "*.tf")

find-modules:
	find -E modules -type f -regex '.*($(MODULE_ROOTS))\.tf$$' -exec dirname "{}" \; | uniq

build-docs:
	$(MAKE) -s find-modules | xargs -I %s terraform-docs markdown table --output-file README.md %s

docs: $(TERRAFORM_SOURCES)
	$(MAKE) -s build-docs
	openssl sha256 $(TERRAFORM_SOURCES) > docs

.PHONY: find-modules build-docs
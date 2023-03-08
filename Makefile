MODULE_ROOTS := main|site
TERRAFORM_SOURCES := $(shell find ./azure -name "*.tf")

find-modules:
	find -E azure -type f -regex '.*($(MODULE_ROOTS))\.tf$$' -exec dirname "{}" \; | uniq

build-docs:
	$(MAKE) -s find-modules | xargs -n 1 terraform-docs markdown table --output-file README.md

docs: $(TERRAFORM_SOURCES)
	$(MAKE) -s build-docs; openssl sha256 $(TERRAFORM_SOURCES) > docs
	
release:
	gh workflow run release.yml -r publicise-repo

.PHONY: find-modules build-docs release
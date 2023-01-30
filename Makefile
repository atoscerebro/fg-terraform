MODULE_ROOTS := main|site
TERRAFORM_SOURCES := $(shell find ./azure -name "*.tf")

find-modules:
	find -E azure -type f -regex '.*($(MODULE_ROOTS))\.tf$$' -exec dirname "{}" \; | uniq

build-docs: $(TERRAFORM_SOURCES)
	$(MAKE) -s find-modules | xargs -I %s terraform-docs markdown table --output-file README.md %s;
	touch build-docs

.PHONY: find-modules
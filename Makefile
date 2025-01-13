.PHONY: test/policy
test/policy: ## Run policy tests
	@if ! type opa >/dev/null 2>&1; then \
		echo "please install opa"; \
	fi
	opa test -v ./policies

.PHONY: build/template
build/template: ## Build the template
	@if ! type konstraint >/dev/null 2>&1; then \
		@echo "please install konstraint"; \
	fi
	konstraint create policies
	./hack/mv-templates.sh

.PHONY: test/gatekeeper
test/gatekeeper: ## Run gatekeeper tests
	@if ! type gator >/dev/null 2>&1; then \
		echo "please install gator"; \
	fi
	gator verify -v ./gatekeeper/...



# Makefile config
#===============================================================
help: ## Display this help screen
	echo "Usage: make [task]\n\nTasks:"
	perl -nle 'printf("    \033[33m%-30s\033[0m %s\n",$$1,$$2) if /^([a-zA-Z0-9_\/-]*?):(?:.+?## )?(.*?)$$/' $(MAKEFILE_LIST)

.SILENT: help

.PHONY: $(shell egrep -o '^(\._)?[a-z_-]+:' $(MAKEFILE_LIST) | sed 's/://')

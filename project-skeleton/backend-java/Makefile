ONESHELL:

.PHONY: help
help: ## Show available targets
	@echo "Usage: make <target>"
	@echo ""
	@echo "Targets:"
	@fgrep "##" Makefile | fgrep -v fgrep

.PHONY: lint
lint: ## Fast feedback checks (compile without running tests)
	@echo "[lint] Running Maven check (skip tests)..."
	mvn -q -DskipTests=true test
	@echo "[lint] OK"

.PHONY: test
test: ## Run unit tests
	@echo "[test] Running unit tests..."
	mvn -q test
	@echo "[test] OK"

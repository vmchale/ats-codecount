.PHONY: ci

ci: .github/workflows/ats.yml

.github/workflows:
	mkdir -p $@

.github/workflows/ats.yml: ci.dhall .github/workflows
	dhall-to-yaml --file $< --output $@

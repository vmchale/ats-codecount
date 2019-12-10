.PHONY: ci

ci: .github/workflows/ats.yml .github/workflows/toml.yml

.github/workflows:
	mkdir -p $@

.github/workflows/toml.yml: toml-ci.dhall .github/workflows
	dhall-to-yaml --file $< --output $@

.github/workflows/ats.yml: ci.dhall .github/workflows
	dhall-to-yaml --file $< --output $@

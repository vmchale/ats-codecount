.PHONY: ci

MAKEFLAGS += --warn-undefined-variables --no-builtin-rules -j

ci: .github/workflows/ats.yml .github/workflows/dhall.yml .github/workflows/toml.yml

.github/workflows:
	mkdir -p $@

.github/workflows/toml.yml: toml-ci.dhall .github/workflows
	dhall-to-yaml-ng --file $< --output $@

.github/workflows/ats.yml: ci.dhall .github/workflows
	dhall-to-yaml-ng --file $< --output $@

.github/workflows/dhall.yml: dhall-ci.dhall .github/workflows
	dhall-to-yaml-ng --file $< --output $@

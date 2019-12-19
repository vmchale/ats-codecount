.PHONY: ci

MAKEFLAGS += --warn-undefined-variables --no-builtin-rules -j

ci: .github/workflows/ats.yml .github/workflows/dhall.yml

.github/workflows:
	mkdir -p $@

.github/workflows/ats.yml: ci.dhall .github/workflows
	dhall-to-yaml --file $< --output $@

.github/workflows/dhall.yml: dhall-ci.dhall .github/workflows
	dhall-to-yaml --file $< --output $@

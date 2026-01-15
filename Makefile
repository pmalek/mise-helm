PROJECT_DIR := $(shell dirname $(abspath $(lastword $(MAKEFILE_LIST))))
MISE := $(shell which mise)
MISE_FILE := .mise.toml
MISE_DATA_DIR ?= $(PROJECT_DIR)/bin/
OS := $(shell uname | tr '[:upper:]' '[:lower:]')
ARCH := $(shell uname -m | sed 's/x86_64/amd64/' | sed 's/aarch64/arm64/')


.PHONY: mise
mise:
	@mise -V >/dev/null 2>/dev/null || (echo "mise - https://github.com/jdx/mise - not found. Please install it." && exit 1)

.PHONY: mise-plugin-install
mise-plugin-install: mise
	$(MISE) plugin install --yes -q $(DEP) $(URL)

.PHONY: mise-install
mise-install: mise
	MISE_DATA_DIR=$(PROJECT_DIR)/bin/ $(MISE) install -q $(DEP_VER)

# NOTE: some tools like helm are to be used by users inside the operator directory.
# Installing them to bin/ will make them unavailable unless MISE_DATA_DIR env variable
# is set to $(PROJECT_DIR)/bin/, which is not outside of this Makefile.
# Hence installing such tools globally on the system.
.PHONY: mise-install-global
mise-install-global: mise
	@$(MISE) install -q $(DEP_VER)

# Do not store yq's version in .tools_versions.yaml as it is used to get tool versions.
# renovate: datasource=github-releases depName=mikefarah/yq
YQ_VERSION = 4.50.1
YQ = $(PROJECT_DIR)/bin/installs/github-mikefarah-yq/$(YQ_VERSION)/yq_$(OS)_$(ARCH)
.PHONY: yq
yq: mise
	$(MAKE) mise-install DEP_VER=github:mikefarah/yq@$(YQ_VERSION)
HELM_VERSION = $(shell $(YQ) -p toml -o yaml '.tools["http:helm"].version' < $(MISE_FILE))
HELM = helm
.PHONY: download.helm
download.helm: mise yq
	$(MAKE) mise-install-global DEP_VER=http:helm

.PHONY: helm.version
helm.version: download.helm
	$(HELM) version

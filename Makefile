BASE=lib/src
TMP=tmp
TARGET_DIR=targets
BIN=node_modules/.bin
TARGETS=$(wildcard $(BASE)/$(TARGET_DIR)/**/index.*)

# Clean directories
clean:
	rm -rf $(BASE)/$(TMP)/* $(BASE)/$(APP)/components $(BASE)/node_modules

build:
	@echo 'Production: building...'
	@NODE_ENV=production node $(BASE)/build.js '$(TARGETS)'

dev:
	@echo 'Development: building...'
	@NODE_ENV=development node $(BASE)/build.js '$(TARGETS)'

serve:
	@echo 'Serving assets in $(BASE)/$(TMP)'
	node $(BASE)/server.js

watch:
	@echo 'Watching assets in targets'
	$(BIN)/wach -o "$(BASE)/$(TARGET_DIR)/**/*" make dev

.PHONY: all clean build dev watch

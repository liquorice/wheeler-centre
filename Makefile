BASE=lib/src
APP=public
TMP=tmp
BIN=node_modules/.bin
TARGETS=$(wildcard $(BASE)/targets/**/index.*)

# Clean directories
clean:
	rm -rf $(BASE)/$(TMP)/* $(BASE)/$(APP)/components $(BASE)/node_modules

build:
	@echo 'Production: building...'
	@NODE_ENV=production node $(BASE)/$(APP).js

dev:
	@echo 'Development: building...'
	@NODE_ENV=development node $(BASE)/build.js '$(TARGETS)'

serve:
	@echo 'Serving assets in $(BASE)/$(TMP)'
	node $(BASE)/server.js

watch:
	@echo 'Watching assets in $(APP)'
	$(BIN)/wach -o "$(BASE)/$(APP)/**/*" make dev

.PHONY: all clean build dev watch

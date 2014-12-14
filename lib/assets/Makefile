APP=public
TMP=tmp
BIN=node_modules/.bin

# Clean directories
clean:
	rm -rf $(TMP)/assets/* $(APP)/components

build:
	@echo 'Production: building...'
	@NODE_ENV=production node ./$(APP).js

dev:
	@echo 'Development: building...'
	@NODE_ENV=development node ./$(APP).js

serve:
	@echo 'Serving assets in $(TMP)'
	node server.js

watch:
	@echo 'Watching assets in $(APP)'
	$(BIN)/wach -o "$(APP)/**/*" make dev

.PHONY: all clean build dev watch

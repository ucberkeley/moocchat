
FILES = $(shell find app config features lib spec db/migrate -type f)

TAGS: $(FILES)
	@etags $(FILES) >/dev/null

.PHONY: check
check:
	rake db:drop
	/bin/rm -rf tmp
	rake db:create
	rake db:reset
	rake spec
	rake spec:javascript
	rake cucumber


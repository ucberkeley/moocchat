
FILES = $(shell find app config features lib spec db/migrate -type f)

TAGS: $(FILES)
	@etags $(FILES) >/dev/null

.PHONY: check
check:
	/bin/rm $(shell rails r -e development "puts Rails.configuration.database_configuration['development']['database']")
	/bin/rm -rf tmp
	rake db:migrate
	rake db:seed
	rake db:test:prepare
	rake spec
	rake spec:javascript
	rake cucumber


version = $(shell cat package.json | grep version | awk -F'"' '{print $$4}')

install:
	@npm install

publish:
	@npm publish
	@git tag $(version)
	@git push origin $(version)

test:
	@npm test


.PHONY: install publish test

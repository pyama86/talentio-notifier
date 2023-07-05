VERSION=$(shell cat version)
version:
	@git describe --tags --always | sed -e 's/v//g' > version
build: version
	docker build --platform linux/amd64 --build-arg VERSION=$(VERSION) -t talentio-notifier .

push: build
	docker tag talentio-notifier  pyama/talentio-notifier:$(VERSION)
	docker tag talentio-notifier  pyama/talentio-notifier:latest
	docker push pyama/talentio-notifier:$(VERSION)
	docker push pyama/talentio-notifier:latest

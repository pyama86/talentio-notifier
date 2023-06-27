VERSION=0.3.6
build:
	docker build --platform linux/amd64 -t talentio-notifier .

push: build
	docker tag talentio-notifier  pyama/talentio-notifier:$(VERSION)
	docker push pyama/talentio-notifier:$(VERSION)

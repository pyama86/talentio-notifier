VERSION=0.3.6
build:
	docker build -t talentio-notifier .

push: build
	docker tag talentio-notifier  pyama/talentio-notifier:$(VERSION)
	docker push pyama/talentio-notifier:$(VERSION)

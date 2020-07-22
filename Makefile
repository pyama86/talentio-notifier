VERSION=0.0.1
build:
	docker build -t talentio-notifier .

push: build
	docker tag talentio-notifier  pyama/talentio-notifier:$(VERSION)
	docker push pyama/talentio-notifier:$(VERSION)
	sed -i 's/talentio-notifier:*/talentio-notifier:$(VERSION)/g' manifests/cron.yml

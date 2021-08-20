# Meta-Makefile that uses docker-compose and Docker
# to rebuild OpenSSH packages.
.PHONY: packages bullseye buster clean

clean:
	rm -f packages/*.deb

bullseye:
	make packages RELEASE=bullseye

buster:
	make packages RELEASE=buster

packages:
	docker-compose build --force-rm --build-arg RELEASE=$(RELEASE)
	docker-compose up --no-build --remove-orphans
	docker-compose down --rmi all --remove-orphans
	rm -f packages/*dbgsym*.deb

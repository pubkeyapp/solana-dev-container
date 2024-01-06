IMAGE=ghcr.io/pubkeyapp/solana-dev-container:latest

build:
	@docker build . -f Dockerfile -t ${IMAGE}

push:
	@docker push ${IMAGE}

run:
	@docker run -it --init -p 8899:8899 --rm --hostname solana-dev --name solana-dev-container ${IMAGE}

run-sh:
	@docker run -it --init -p 8899:8899 --rm --hostname solana-dev --name solana-dev-container ${IMAGE} sh

run-test-validator:
	@docker run -it --init -p 8899:8899 --rm --hostname solana-dev --name solana-dev-container ${IMAGE} solana-test-validator



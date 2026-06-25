.PHONY: up down logs keys secret

up:
	docker compose up -d

down:
	docker compose down

logs:
	docker compose logs -f

keys:
	docker run --rm ghcr.io/xtls/xray-core:latest x25519

secret:
	openssl rand -hex 16

deploy:
	bash deploy.sh

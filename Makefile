SHELL := /bin/bash

# Install dependencies for each microservice locally so you don't get errors 
install:
	pushd ./app/auth && pnpm i && popd && \
	pushd ./app/client && pnpm i && popd && \
	pushd ./app/common && pnpm i && popd && \
	pushd ./app/expiration && pnpm i && popd && \
	pushd ./app/orders && pnpm i && popd && \
	pushd ./app/payments && pnpm i && popd && \
	pushd ./app/products && pnpm i && popd \

# Boot up all microservices on k8s http://localhost:80
dev: 
	skaffold dev 

devclean: 
	skaffold dev --cache-artifacts-false

# Deploy all microservices to production
prod: 
	skaffold dev -p production

# Boot up just a single microservice using docker compose
# http://localhost:3000
devauth:
	pushd ./app/auth && pnpm dev:local && popd

devclient:
	pushd ./app/client && pnpm dev && popd

lintclient:
	pushd ./app/client && pnpm lint && popd

# Publish the common package (/app/common) to the npm registry so 
# that my microservices can use the updated code and then download
# the new version to all my microservices
publish:
	pushd ./app/common && pnpm publish:patch && popd && \
	pushd ./app/auth && pnpm install @weibuddies/common@latest && popd && \
	pushd ./app/expiration && pnpm install @weibuddies/common@latest && popd && \
	pushd ./app/orders && pnpm install @weibuddies/common@latest && popd && \
	pushd ./app/payments && pnpm install @weibuddies/common@latest && popd && \
	pushd ./app/products && pnpm install @weibuddies/common@latest && popd \

lint:
	pushd ./app/auth && pnpm lint && popd && \
	pushd ./app/client && pnpm lint && popd && \
	pushd ./app/common && pnpm lint && popd && \
	pushd ./app/expiration && pnpm lint && popd && \
	pushd ./app/orders && pnpm lint && popd && \
	pushd ./app/payments && pnpm lint && popd && \
	pushd ./app/products && pnpm lint && popd \
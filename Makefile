.PHONY: help
help: ## Print this help information
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"; printf "\nTargets:\n"} /^[$$()% a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m	 %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

.PHONY: build
build: ## Builds the kube services Docker image
	docker build -t kube:latest .
	minikube image rm kube:latest
	minikube image load kube:latest

.PHONY: init
init: ## Initializes the kube service on the minikube cluster
	kubectl apply -f .k8s/0-namespace.yml
	kubectl apply -f .k8s/1-service.yml
	kubectl apply -f .k8s/2-deployment.yml

.PHONY: stop
stop: ## Stops the kube services deployment on the minikube cluster
	kubectl scale deploy -n kube kube --replicas=0

.PHONY: start
start: ## Starts the kube services deployment on the minikube cluster
	kubectl apply -f .k8s/3-deployment.yml

.PHONY: dev
dev: ## Runs the kube services dev environment on the minikube cluster
	okteto up -n kube -f .okteto.yml

.PHONY: prod
prod: ## Removes the kube services dev environment from the minikube cluster
	okteto down -n kube -f .okteto.yml

.PHONY: update
update: prod build stop start ## Updates the kube service on the minikube cluster

.PHONY: clean
clean: ## Removes the kube service from the minikube cluster
	okteto down -n kube -f .okteto.yml -v

	kubectl delete -f .k8s/2-deployment.yml
	kubectl delete -f .k8s/1-service.yml
	kubectl delete -f .k8s/0-namespace.yml
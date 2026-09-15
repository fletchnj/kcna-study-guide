.PHONY: help lint validate-manifests test deploy-configmaps deploy-secrets deploy-labels deploy-probes deploy-capstone clean

help:
	@echo "KCNA Exam Demo: Configuration & Health Lab Runner"
	@echo ""
	@echo "Available commands:"
	@echo "  make validate-manifests   Validate all YAML manifests using client-side dry run"
	@echo "  make deploy-configmaps    Apply Module 1 (ConfigMaps) to active cluster"
	@echo "  make deploy-secrets       Apply Module 2 (Secrets) to active cluster"
	@echo "  make deploy-labels        Apply Module 3 (Labels & Annotations) to active cluster"
	@echo "  make deploy-probes        Apply Module 4 (Probes) to active cluster"
	@echo "  make deploy-capstone      Apply Module 5 (Capstone Microservice) to active cluster"
	@echo "  make deploy-all           Apply all demo manifests sequentially"
	@echo "  make clean                Delete all demo resources created across all labs"

validate-manifests:
	@echo "Validating Kubernetes manifests..."
	@for f in $$(find . -name "*.yaml" -not -path "./.github/*"); do \
		echo "Validating $$f..."; \
		kubectl create --dry-run=client --validate=false -f "$$f" >/dev/null || exit 1; \
	done
	@echo "All manifests validated successfully!"

deploy-configmaps:
	kubectl apply -f 01-configmaps/01-literal-env-configmap.yaml
	kubectl apply -f 01-configmaps/02-volume-configmap.yaml
	kubectl apply -f 01-configmaps/03-immutable-configmap.yaml
	kubectl apply -f 01-configmaps/04-demo-pod.yaml

deploy-secrets:
	kubectl apply -f 02-secrets/01-opaque-secret.yaml
	kubectl apply -f 02-secrets/02-tls-secret.yaml
	kubectl apply -f 02-secrets/03-demo-pod.yaml

deploy-labels:
	kubectl apply -f 03-labels-and-annotations/01-labeled-pods.yaml
	kubectl apply -f 03-labels-and-annotations/02-service-selector.yaml
	kubectl apply -f 03-labels-and-annotations/03-node-selector-pod.yaml
	kubectl apply -f 03-labels-and-annotations/04-annotated-pod.yaml

deploy-probes:
	kubectl apply -f 04-probes/01-liveness-exec.yaml
	kubectl apply -f 04-probes/02-readiness-http.yaml
	kubectl apply -f 04-probes/03-startup-probe.yaml
	kubectl apply -f 04-probes/04-multi-probe-app.yaml

deploy-capstone:
	kubectl apply -f 05-capstone-app/deployment.yaml
	kubectl apply -f 05-capstone-app/service.yaml

deploy-all: deploy-configmaps deploy-secrets deploy-labels deploy-probes deploy-capstone

clean:
	@echo "Cleaning up demo resources..."
	-kubectl delete -f 05-capstone-app/service.yaml --ignore-not-found
	-kubectl delete -f 05-capstone-app/deployment.yaml --ignore-not-found
	-kubectl delete -f 04-probes/ --ignore-not-found
	-kubectl delete -f 03-labels-and-annotations/ --ignore-not-found
	-kubectl delete -f 02-secrets/ --ignore-not-found
	-kubectl delete -f 01-configmaps/ --ignore-not-found
	@echo "Cleanup completed."

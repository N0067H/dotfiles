set shell := ["bash", "-euo", "pipefail", "-c"]

cluster := "dev"

default:
    @just --list

# Create a local Docker-backed Kubernetes cluster.
k8s-up:
    docker info > /dev/null
    KIND_EXPERIMENTAL_PROVIDER=docker kind create cluster --name {{cluster}} --config kubernetes/kind.yaml --wait 120s
    kubectl --context kind-{{cluster}} wait --for=condition=Ready nodes --all --timeout=120s

# Inspect the local cluster regardless of the current kubectl context.
k8s-status:
    kubectl --context kind-{{cluster}} get nodes -o wide
    kubectl --context kind-{{cluster}} get pods -A

# Load a locally built image, e.g. just k8s-load my-app:dev.
k8s-load image:
    KIND_EXPERIMENTAL_PROVIDER=docker kind load docker-image {{quote(image)}} --name {{cluster}}

# Open the cluster UI.
k8s-ui:
    k9s --context kind-{{cluster}}

# Delete the dev cluster and all workloads/data stored in it.
k8s-down:
    KIND_EXPERIMENTAL_PROVIDER=docker kind delete cluster --name {{cluster}}

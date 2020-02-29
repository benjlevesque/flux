# Flux Configuration

This is a [flux](https://fluxcd.io)-based repo for a kubernetes cluster configuration.

The following details how to deploy this configuration to a new cluster.

## Prerequisites

- admin access to a blank kubernetes cluster
- kubectl (already configured)
- [helm 3](https://helm.sh/)

## Setup

### Configure cert-manager to ignore kube-system

```
kubectl label namespace kube-system certmanager.k8s.io/disable-validation="true"
```

### Install Flux

```
helm repo add fluxcd https://charts.fluxcd.io
kubectl apply -f https://raw.githubusercontent.com/fluxcd/helm-operator/master/deploy/flux-helm-release-crd.yaml

helm upgrade -i flux fluxcd/flux \
--set git.url=git@github.com:benjlevesque/flux \
--namespace flux

helm upgrade -i helm-operator fluxcd/helm-operator \
--set git.ssh.secretName=flux-git-deploy \
--set helm.versions=v3 \
--namespace flux
```

### Give flux access to the repository

- get the flux SSH key

```
fluxctl identity --k8s-fwd-ns flux
```

- add the key to [github](https://github.com/benjlevesque/flux/settings/keys/new)

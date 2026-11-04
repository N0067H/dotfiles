## Shell and development tools

Zsh uses Starship, zoxide, fzf integration, autosuggestions, and syntax
highlighting. CLI tools and language toolchains are listed in
`nixos/modules/packages.nix`.

| Alias | Command / purpose |
| --- | --- |
| `ll` / `la` / `tree` | eza listings and tree view |
| `ff` | fastfetch |
| `gs` / `gd` / `ga` / `gc` / `gp` / `gl` | Git status / diff / add / commit / push / log |
| `nrt` / `nrs` | Test / switch `~/dev/dotfiles#nixos` |
| `dots` | Change to `~/dev/dotfiles` |
| `k` / `kctx` / `kns` | kubectl / kubectx / kubens |

### Local Kubernetes

The Kubernetes module installs kubectl, Helm, kind, k9s, kubectx/kubens,
Kustomize, Skaffold, Stern, and kubeconform. Docker starts on boot; the kind
cluster is created explicitly. After applying Docker group membership, log
out and back in before using it.

```bash
cd ~/dev/dotfiles
just k8s-up
just k8s-status
just k8s-ui
```

[`kubernetes/kind.yaml`](../kubernetes/kind.yaml) defines a single control-plane
node with a digest-pinned `kindest/node:v1.35.0` image and a localhost API.
The cluster name is `dev`, and the kubectl context is `kind-dev`.

```bash
docker build -t my-app:dev /path/to/app
just k8s-load my-app:dev
kubectl --context kind-dev apply -f /path/to/app/k8s/
kubectl --context kind-dev port-forward service/my-app 8080:80
stern --context kind-dev my-app
```

Use `image: my-app:dev` and `imagePullPolicy: IfNotPresent` for locally loaded
images. `just k8s-down` deletes the cluster and its workloads/data. Credentials
remain in the local kubeconfig, outside this repository.

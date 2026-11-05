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

### AI tools (llm-agents.nix)

The flake installs the upstream `llm-agents-launcher` and configures Numtide's
binary cache. Run the launcher, search for a tool, and press Enter to run it;
press Esc to cancel. Tools are downloaded on demand and may require their own
login or API key. The launcher fetches the latest upstream revision when running
a selected tool; the installed launcher itself is pinned by `flake.lock`.

```bash
llm-agents-launcher
# Run a particular tool without the picker:
nix run github:numtide/llm-agents.nix#claude-code
nix run github:numtide/llm-agents.nix#opencode
```

To install a tool permanently, add e.g. `llm-agents.packages.${system}.claude-code`
next to the launcher in `flake.nix`, then apply the configuration:

```bash
cd ~/dev/dotfiles
sudo nixos-rebuild switch --flake .#nixos
```

To update the pinned package collection and launcher:

```bash
nix flake update llm-agents
sudo nixos-rebuild switch --flake .#nixos
```

Keep llm-agents' own nixpkgs input: upstream tests against its unstable pin,
while this system uses stable nixpkgs. See the
[upstream usage guide](https://github.com/numtide/llm-agents.nix#usage).

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

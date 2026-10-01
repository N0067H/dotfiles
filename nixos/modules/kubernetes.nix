{ pkgs, ... }:

{
  # Local clusters run on the Docker daemon configured in docker.nix.
  environment.systemPackages = with pkgs; [
    kubectl
    kubernetes-helm
    kind
    k9s
    kubectx # Includes kubens.
    kustomize
    skaffold
    stern
    kubeconform
  ];
}

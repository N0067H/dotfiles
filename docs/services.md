## Other services and application integration

The host also enables PostgreSQL 16 (with `mydatabase`), Tailscale, Cloudflare
WARP, Bluetooth/Blueman, printing, Flatpak, and an 80% battery charge threshold
when the machine exposes the configured `BAT0` control file. Review these in
`nixos/modules/services.nix` and `nixos/modules/desktop.nix` when reusing the setup.

Codex Desktop is installed from a flake input. The setup script links only its
`electron-flags.conf` for Wayland rendering. The `bin/codex` wrapper uses a
locally installed executable under `~/.codex/packages/app-server-daemon/releases`;
it requires that executable to already exist. Application runtime data,
sessions, credentials, caches, and local storage remain outside this repository.

For WARP, after applying the system configuration:

```bash
warp-cli registration new
warp-cli connect
warp-cli status
```

Accept the registration terms if prompted. Use `warp-cli disconnect` to
disconnect. Registration data lives outside the repository in
`/var/lib/cloudflare-warp`.

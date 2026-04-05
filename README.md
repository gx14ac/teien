## teien - NixOS / nix-darwin System Configurations

Declarative development environment for NixOS and macOS (nix-darwin).
Manages CLI tools, GUI apps, shell, editor, and terminal configuration entirely through Nix.

### macOS Setup (nix-darwin)

#### Prerequisites

1. Install Nix using the Determinate Nix installer:
```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

2. Clone this repository:
```bash
git clone https://github.com/gx14ac/teien.git ~/git/github.com/gx14ac/teien
cd ~/git/github.com/gx14ac/teien
```

#### Initial Setup

```bash
nix run nix-darwin -- switch --flake ".#darwin"
```

#### Making Changes

```bash
NIXPKGS_ALLOW_UNFREE=1 nix build --impure ".#darwinConfigurations.darwin.system"
sudo NIXPKGS_ALLOW_UNFREE=1 ./result/sw/bin/darwin-rebuild switch --impure --flake ".#darwin"
```

Or use the Makefile:

```bash
NIXNAME=darwin make switch
```

#### What Gets Installed

- **CLI tools**: fish, neovim, git, tmux, cmake, gh, etc. (managed by Nix via home-manager)
- **GUI apps**: 1Password, Claude, Ghostty, Slack, etc. (managed by Homebrew)
- **Terminal**: Ghostty (Homebrew cask) with nix-managed config
- **System settings**: Dock, Finder, keyboard preferences

#### Notes

- **Homebrew `cleanup = "zap"` is enabled.** Any Homebrew package not listed in `darwin.nix` (`brews` / `casks`) will be removed on `darwin-rebuild switch`. Add new CLI tools to `home.packages` in `home-manager.nix` instead.
- **Ghostty config is OS-specific:** `ghostty.darwin` (macOS) / `ghostty.linux` (NixOS VM). Do not use the `command` option on macOS as it conflicts with Ghostty's `/usr/bin/login` wrapper.
- **chezmoi** runs automatically via `home.activation`. Ensure chezmoi-managed files do not conflict with home-manager-managed files.

---

### NixOS VM Setup

Boot the VM, and using the graphical console, change the root password to "root":

```
$ sudo su
$ passwd
```

Verify `/dev/sda` exists. If `/dev/nvme` or `/dev/vda` exists instead, modify the `bootstrap0` Makefile task to use the correct block device paths.

Set the VM IP address and architecture:

```
$ export NIXADDR=<VM ip address>
$ export NIXNAME=vm-aarch64  # for ARM-based processors
```

Bootstrap the VM:

```
$ make vm/bootstrap0
```

After reboot, finalize the configuration:

```
$ make vm/bootstrap
```

Apply further changes with `make vm/rebuild`.

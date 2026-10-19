# INFO: -----------------------
#         configuration
# -----------------------------

set shell := ["bash", "-c"]

os_family := os()
open_cmd := if os_family == "macos" { "open" } else { "xdg-open" }

# project defaults
default_user := "mason"
default_host := if os_family == "macos" { "masonmac" } else { "worldgov" }

# lists all available recipes, in file order so niche groups stay at the bottom
[private]
default:
    @just --list --unsorted

# INFO: -----------------------
#         system & home
# -----------------------------

# switches home-manager configuration for the given user and host
[group("switch")]
switch-home user=default_user host=default_host:
    home-manager switch --flake .#{{user}}@{{host}}

# rebuilds and switches the nixos system configuration
[group("switch")]
switch-system host="worldgov":
    sudo nixos-rebuild switch --flake .#{{host}}

# INFO: ---------------------
#         maintenance
# ---------------------------

# cleans home-manager generations older than 3 days, runs garbage collection, and optimizes the store
[group("maintenance")]
clean:
    @echo "==> Expiring home-manager generations older than 3 days..."
    @if command -v home-manager >/dev/null 2>&1; then \
        home-manager expire-generations "-3 days"; \
    fi
    @echo "==> Collecting nix garbage..."
    nix-collect-garbage -d
    @echo "==> Optimizing nix store..."
    nix store optimise

# expires home-manager generations older than the specified duration (default: -3 days)
[group("maintenance")]
expire-generations age="-3 days":
    home-manager expire-generations "{{age}}"

# collects all nix garbage and removes old profile links
[group("maintenance")]
gc:
    nix-collect-garbage -d

# optimizes the nix store by hard-linking duplicate files
[group("maintenance")]
optimise:
    nix store optimise

# INFO: --------------------------
#         flake operations
# --------------------------------

# formats all nix and project files using treefmt
[group("flake")]
fmt:
    nix fmt

# runs nix flake check across the repository
[group("flake")]
check:
    nix flake check

# updates flake inputs lockfile
[group("flake")]
update *args:
    nix flake update {{args}}

# INFO: -----------------
#         secrets
# -----------------------

# edits secrets using sops with the age key configured in devshell
[group("secrets")]
secrets file="secrets/secrets.yaml":
    sops {{file}}

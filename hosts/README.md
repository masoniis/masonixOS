# Hosts

| Host                                   | Personal purpose                                                                  |
| -------------------------------------- | --------------------------------------------------------------------------------- |
| [xpsOnix](./xpsOnix/default.nix)       | Dell XPS 15 laptop running NixOS                                                  |
| [worldGovOS](./worldGovOS/default.nix) | Media server and utility host running NixOS                                       |
| [wslOnix](./wslOnix/default.nix)       | Generalized [NixOS-WSL](https://github.com/nix-community/NixOS-WSL) configuration |
| [masongov](./masongov/default.nix)     | Isolated home-manager configuration for Linux                                     |
| [masonmac](./masonmac/default.nix)     | MBP 14" M1 Pro on MacOS using home-manager[^1]                                    |

[^1]: Currently using `home-manager` without `nix-darwin` to manage mac. I don't think I personally need the system configuration settings and `nix-darwin` previously broke my nix setup so I decided to opt out of using it.

## Host Utilities (`hostUtils.nix`)

All hosts are defined using helpers in `hostUtils.nix`. This allows for a consistent setup across different machines while remaining modular.

### `nixosSystem`

Used for standard NixOS systems without built-in home-manager.

- `system`: The architecture (e.g., `"x86_64-linux"`).
- `config`: Configuration attributes.
- `extraModules`: List of additional NixOS modules to include.

### `nixosHomeManagerSystem`

Used for NixOS systems with home-manager integrated.

- `system`: The architecture.
- `username`: The primary user.
- `config`: Home-manager configuration attributes.
- `extraModules`: List of NixOS modules.
- `extraHomeModules`: List of home-manager modules.
- `useDefaultHomeModules`: (Default: `true`) Whether to include standard modules (Linux defaults, nixCats, spicetify).

### `homeManagerSetup`

Used for standalone home-manager configurations (e.g., on macOS or non-NixOS Linux).

- `system`: The architecture.
- `username`: The user.
- `config`: Home-manager configuration attributes.
- `extraModules`: List of home-manager modules.
- `useDefaultModules`: (Default: `true`) Whether to include standard platform-specific modules.

## Usage

Since the hosts have a mix of `home-manager` exclusive configurations as well as `nixos` configurations that automatically include `home-manager` modules, the setup can vary slightly on a fresh machine.

### NixOS configs

```bash
sudo nixos-rebuild switch --flake .#hostname
```

### MacOS / Standalone home-manager

```bash
home-manager switch --flake .#user@hostname
```

## Available options when creating new hosts

Hosts can set config options such as `entertainment.enable = true;`. The following is a list of options available and what they do.

| Option                 | Description                                                                                                 | Default                 |
| ---------------------- | ----------------------------------------------------------------------------------------------------------- | ----------------------- |
| `entertainment.enable` | Enable entertainment packages related to media                                                              | `false`                 |
| `personal.enable`      | Enable personal [packages](../modules/common/personal/default.nix) including gaming and note-taking         | `false`                 |
| `language.XXXX.enable` | Enable specific language modules, list shown [here](../modules/common/dev/languages/default.nix)            | `varies by langauge`    |
| `flakePath`            | Path for the flake used in alias commands like `nrswitch` defined [here](../modules/common/system/home.nix) | `"~/.config/masonixOS"` |

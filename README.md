# Extensible Nix Configuration

An extensible Nix configuration for declarative software deployment across multi-host Unix system clusters (like Proxmox guest machines).

- configuration management system that lets you deploy consistently across multiple hosts using a unique attribute set squashing mechanism
- configuration from multiple layers into one Nix derivation per host.

## How It Works

### The vars.nix Logic

The core of this system lives in `vars/vars.nix`, which creates a three-layer configuration hierarchy:

1. **Global Defaults** (`defaults`) - Base config that applies everywhere
2. **Category Configs** (`categories`) - Settings for host types (desktop, server, etc.)
3. **Host Overrides** - Individual host configs that override everything else

#### The Configuration Squashing Function

The `getHostVars` function:

```nix
getHostVars = hostname:
  let
    hostConfig = hosts.${hostname} or {};
    categoryName = hostConfig.category or null;
    categoryConfig = if categoryName != null then categories.${categoryName} or {} else {};
    mergedConfig = defaults // categoryConfig // hostConfig;
  in
  mergedConfig // {
    home = "/home/${mergedConfig.usr}";
    homeDir = if mergedConfig ? homeDir then mergedConfig.homeDir else "/home/${mergedConfig.usr}";
  };
```

This function:

- Grabs the host-specific config
- Figures out what category the host belongs to
- Merges everything with the right precedence: `defaults < categoryConfig < hostConfig`
- Generates dynamic values like home directory paths

#### Host Categories

- **desktop** - Workstations with GUI, hardware dev's like Bluetooth
- **server** - Server configs, virtualisation

## Project Structure

```
nix-config/
├── flake.nix                    # Entry point, imports vars.nix
├── configuration.nix            # Main config module
├── vars/
│   └── vars.nix                # Core logic and host definitions
├── hosts/
│   └── servers/                # Host-specific stuff
├── programs/                   # App configurations
│   ├── git/
│   └── tealdeer/
├── services/                   # System services
├── sys.nix                     # System-level config
└── pkgs.nix                   # Package definitions
```

- Functional configuration management
- Reproducible builds
- Version control for your entire infrastructure
- Smart config merging
- CPU & GPU type configuration, Filesystem handling (BTRFS support), EFI or BIOS boot

## How to Use

### Adding a New Host

1. Add your host to the `hosts` attribute set in `vars.nix`
2. Give it a category ("desktop", "server", etc.)
3. Override any global or category settings you need
4. Drop host-specific config files in `hosts/[hostname]/`

### Adding a New Category

1. Add it to the `categories` attribute set in `vars.nix`
2. Set up default hardware and software configs
3. Define category-specific behaviors

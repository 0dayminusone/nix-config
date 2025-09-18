{ pkgs, vars, inputs, ... }:
{
  nixpkgs.overlays = [
    (final: prev: { unstable = import inputs.nixpkgs-unstable { system = final.system; config.allowUnfree = false; }; })
  ];
  environment.systemPackages = with pkgs; [
    # Sys Stuff
    grub2 #### bootloader
    fish #### usr shell
    any-nix-shell
    sudo-rs #### for nixos rebuild-switch

    # CLI apps
    git
    duf
    neovim
    bat
    eza
    fzf
    sysz
    fd #### better find file prog
    ripgrep
    ripgrep-all #### rg for PDF's, binaries, etc.
    gping
    lazygit
    gdu
    fast-ssh #### SSH TUI manager
    tealdeer
    wget

    ## Sysmons
    btop
    powertop
    kmon
    usbtop
    nix-tree

    # Networking
  ] ++ lib.optionals (vars.isBtrfs == true) [
    # Filesystem = BTRFS
    snapper
    btrfs-progs
    btrfs-list #### Lists BTRFS Snapshots & Subvolumes
    btdu #### ncdu but for BTRFS (because of things like .snapshots, etc.)
  ] ++ lib.optionals (vars.inTailnet == true ) [
    # Networking
    netstat
  ];
  programs = {
    nano.enable = false; #### Disabling Nano
  };
}

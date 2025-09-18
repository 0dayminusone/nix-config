{ config, pkgs, lib, vars, ... }:
{
  # Home Manager
  home-manager = {
    useGlobalPkgs = true;
    backupFileExtension = vars.hmBackupExt;
    users."${vars.usr}" = { pkgs, ... }: { home.stateVersion = vars.initalState; }; #### Inital Version of home manager pkgs
  };


  # Filesystem
  ## Snapper
  services.snapper = lib.mkIf vars.isBtrfs {
    snapshotInterval = "daily";
    persistentTimer = true;
    ### Conf
    configs = {
      root = {
        SUBVOLUME = "/";
        FSTYPE = "btrfs";
        TIMELINE_CLEANUP = true;
        TIMELINE_LIMIT_DAILY = 3;
        TIMELINE_LIMIT_WEEKLY = 4;
        TIMELINE_LIMIT_QUATERLY = 3;
        TIMELINE_LIMIT_YEARLY = 1;
        TIMELINE_CREATE = true;
      };
      home = {
        SUBVOLUME = "/home";
        TIMELINE_CLEANUP = true;
        TIMELINE_LIMIT_DAILY = 3;
        TIMELINE_LIMIT_WEEKLY = 4;
        TIMELINE_LIMIT_QUATERLY = 3;
        TIMELINE_LIMIT_YEARLY = 1;
        TIMELINE_CREATE = true;
      };
    };
  };


  # Internalisation, language & keymap settings
  ## Time zone
  time.timeZone = vars.timeZone;
  i18n.defaultLocale = vars.locale;
  i18n.extraLocaleSettings = {
    LC_ADDRESS = vars.locale;
    LC_IDENTIFICATION = vars.locale;
    LC_MEASUREMENT = vars.locale;
    LC_MONETARY = vars.locale;
    LC_NAME = vars.locale;
    LC_NUMERIC = vars.locale;
    LC_PAPER = vars.locale;
    LC_TELEPHONE = vars.locale;
    LC_TIME = vars.locale;
  };
  ## Console keymap
  console.keyMap = vars.keymap;


  # Hybernate & Sleep
  systemd.targets = lib.mkIf (vars.category == "desktop") {
    hibernate.enable = false;
    hybrid-sleep.enable = true;
  };
 

  # Bootloader
  boot.loader = {
    systemd-boot.enable = false; #### disables systemd-boot infavor of grub
    timeout = vars.grubTimeout;
    efi.canTouchEfiVariables = vars.isEfi;
    ## Grub
    grub = {
      enable = true;
      efiSupport = vars.isEfi;
      gfxmodeEfi = vars.grubEfiRez;
      device = "nodev";
    };
  };


  # Networking
  networking = {
    networkmanager.enable = true;
    hostName = vars.host;
  };
  ## Bluetooth
  hardware.bluetooth = lib.mkIf (vars.wantsBluetooth == true) {
    enable = true;
  };

 
  ## Firewall
  networking.firewall = {
    enable = true;
    allowedTCPPorts = lib.mkForce vars.allowTCP;
    allowedUDPPorts = lib.mkForce vars.allowUDP;
    allowedTCPPortRanges = lib.mkForce vars.firewPortRanges;
    allowedUDPPortRanges = lib.mkForce vars.firewPortRanges;
    trustedInterfaces = vars.trustInterfaces;
  };
  networking.nftables.enable = true;


  # Nix settings
  nix.settings.experimental-features = [ "nix-command" "flakes" ]; #### enables flakes
  nixpkgs.config.allowUnfree = false;
  system.stateVersion = vars.initalState; #### Inital version of /nix/store/


  # Users & Groups
  users.users."${vars.usr}" = {
    isNormalUser = true;
    shell = pkgs.fish;
    useDefaultShell = true;
    extraGroups = vars.mainUsrGrps;
  };
}

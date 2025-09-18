rec {
  defaults = rec {
    # Internationalization, Locales, Language
    locale = "en_GB.UTF-8";
    timeZone = "Europe/London";
    keymap = "uk";
    #### TODO: Implement a "dominant privlage esc tool" variable, do a grep on all instances of 'doas' and find n replace
    # Internal Nix Conf Vars
    hmBackupExt = "hm-backup";
    # Dirs   NOTE: Dont append "/" to the end of paths
    progDir = "${defaults.root}/programs";
    hostDir = "${defaults.root}/hosts";
    # Grub
    grubTimeout = 2;
    grubEfiRez = "auto";
    serverWantsaSSHServer = false;
    serverWantsKDEConnectD = false;
  };

  categories = {
    desktop = rec { #### Dont change names of categories, there is a lot of hardcoding of these strings
      # Hardware
      ## Vars
      isEfi = true; #### Dont change var from a boot
      wantsBluetooth = true;
      isAVirt = false;
      desktopHasBattery = true;
      ## GPU
      gpu = {
        vendor = "amd"; #### or nvidia  NOTE: other GPUs need manual intervention atm
        driver = if gpu.vendor == "amd" then "rocm" else "cuda"; #### AMD 'rocm' or 'cuda' for nvidia
      };
      ## CPU
      cpuType = "amd";
      # Linux
      ## Filesystem
      isBtrfs = true; #### Is the root/ main FS BTRFS?, #### Dont change var from a boot
      ## Firewall
      allowTCP = [];
      allowUDP = [];
      ## Virt
      wantsVirt = true; #### Dont change var from a boot
      ## Mnt
    };

  # Logic :(
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
  getHostsInCategory = categoryName:
    builtins.filter (hostName:
      let hostConfig = hosts.${hostName};
      in hostConfig ? category && hostConfig.category == categoryName
    ) (builtins.attrNames hosts);
  getHostCategory = hostname:
    let hostConfig = hosts.${hostname} or {};
    in hostConfig.category or null;
}

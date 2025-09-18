{ vars, lib, ... }:
{
  # FWUPD (firmware updates)
  services.fwupd.enable = true;


  # For Virtualisation **GUESTS**
  services.qemuGuest.enable = lib.mkIf (vars.isAVirt) true;
  services.spice-vdagentd.enable = lib.mkIf (vars.isAVirt) true; #### copy and paste between host and guest


  # Virtualisation on **HOST MACHINES**
  virtualisation.libvirtd.enable = lib.mkIf (vars.wantsVirt) true;
  virtualisation.spiceUSBRedirection.enable = lib.mkIf (vars.wantsVirt) true;


  # Docker (for the SERVER)
  virtualisation = {
    containers.enable = lib.mkIf (vars.category == "server") true;
    docker = lib.mkIf (vars.category == "server") {
      enable = true;
      daemon.settings = {
        data-root = "~/docker/";
      };
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };
  };
}

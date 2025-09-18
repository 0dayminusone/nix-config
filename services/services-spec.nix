{ pkgs, vars, lib, ... }:
{
  # Game Save Backup
  systemd.user.services.GameSaveBackup = lib.mkIf (vars.category == "desktop") {
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "/bin/sh -e '${vars.installedScriptsDir}/backup.sh'";
    };
    wantedBy = [ "default.target" ];
  };
}

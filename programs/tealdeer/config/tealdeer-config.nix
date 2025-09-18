{ vars, ... }:
{
  home-manager.users."${vars.usr}" = { pkgs, ... }: {
    programs.tealdeer = {
      enable = true;
      settings.updates = {
        auto_update = true;
        auto_update_interval_hours = 24;
      };
    };
  };
}

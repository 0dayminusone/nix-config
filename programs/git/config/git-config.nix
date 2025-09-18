{ vars, ... }:
{
  home-manager.users."${vars.usr}" = { pkgs, ... }: {
    programs.git = {
      enable = true;
    };
  };
}

{ pkgs, inputs, vars, ... }:
{
  environment.systemPackages = with pkgs; [
    # Server Services
    docker

    # CLI progs
    lazydocker
    ethtool
  ];
}

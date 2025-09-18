{ vars, ... }:
{
  imports =  [
    # Packages
    ./pkgs.nix

    # System options
    ./sys.nix

    # Programs' configs
    "${vars.progDir}/git/config/git-config.nix"
    "${vars.progDir}/tealdeer/config/tealdeer-config.nix"

    # Host Specific Config
    "${vars.hostDir}/${vars.host}/configuration.nix"

    # System services
    ./services/services.nix
    ./services/services-spec.nix #### Specifies custom (systemd) services
  ];
}

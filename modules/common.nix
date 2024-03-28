# Baseline "minimal" config, suitable for headless boxes (router, raspberry pi, etc)
# Most hosts extend from ./common.nix instead, which includes quality of life stuff
# like fonts, podman, etc.

{ inputs, outputs, lib, config, pkgs, ... }: {
  # You can import other NixOS modules here
  imports = [
#    inputs.home-manager.nixosModules.home-manager
#    inputs.agenix.nixosModules.default
    ./users.nix


  ];

  programs.bash.shellAliases = {
    vi = "nvim"; # the one editor!
    sudo="sudo "; # fix aliases not working using sudo - the space means carry over aliases
  };


  # Make bash default shell for all
  users.defaultUserShell = pkgs.bash;


# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.n  ix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
   
    # features 
    ../../features/sound.nix

    # modules
    ../../modules/users.nix


    ];


  # Enable zram
  zramSwap = {
    enable = true;
    algorithm = "zstd"; # zstd default
    memoryPercent = 50; # 50 default
    priority = 100; # 5 default, higher = used first
  };

  # 8 GB ssd swap for insane overflow purposes
  swapDevices = [ {
    device = "/var/lib/swapfile";
    size = 8*1024;
    priority = 1; # default null = kernel decides, not optimal!
  } ];


  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;

  # kernel parameters
  # Fix Fn keys = F1-F12 is basic mode
  boot.kernelParams = [ "hid_apple.fnmode=2" ];


  # displaylink
  services.xserver.videoDrivers = [ "displaylink" "modesetting" ];

  # Use latest kernel - already defined in apple-silicon-support
  # boot.kernelPackages = pkgs.linuxPackages_latest;


  # enable GPU support and audio
  hardware.asahi.useExperimentalGPUDriver = true;
  hardware.asahi.experimentalGPUInstallMode = "replace";
  hardware.asahi.setupAsahiSound = true;
 


  # enable flakes + command and allow unfree packages
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
  
  services.flatpak.enable = true;


  # Define hostname
  networking.hostName = "taumac"; 

  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

#  networking.wireless.iwd = {
#    enable = true;
#    settings.General.EnableNetworkConfiguration = true;
#  };

  

  # Set your time zone.
  time.timeZone = "Europe/Copenhagen";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_DK.UTF-8";

  console.keyMap = "dk-latin1";

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.xserver.synaptics.palmDetect = true; 

# services.xserver.displayManager.defaultSession = "plasmawayland";
  
  

  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "dk";
    xkb.variant = "";
  };


  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;


programs.starship.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    git # MUST be first as everything else (in flakes) depends on git



    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    firefox
    mesa-demos
    kitty
    btop
    maestral
    maestral-gui  
    libreoffice-qt
    hunspell
    hunspellDicts.da_DK
    hunspellDicts.en_US
    gh
    neovim

    armcord
    neofetch
    fastfetch
  
  #  zotero - no zotero for aarch64 in nix os - find out how to fix this!
  ];

  environment.variables.EDITOR = "nvim";

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Tailscale
  services.tailscale.enable = true;


  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?

}


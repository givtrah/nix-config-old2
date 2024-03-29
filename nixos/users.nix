{ config, pkgs, ... }:
{
    
 # Define a user account. Don't forget to set a password with ‘passwd’ (as root).
  users.users.ohm = {
     isNormalUser = true;
     extraGroups = [ "wheel" "networkmanager" "libvirtd" ]; # wheel = sudo, networkmanager = change network, libvirtd = qemu. Consider adding input (doing?), docker and video (doing?).
     shell = pkgs.bash;
     packages = with pkgs; [
       pfetch # can be used as check!
     ];
   };

  # Consider adding ssh public keys!

  # allow running nixos-rebuild as root without a password.
  # requires us to explicitly pull in nixos-rebuild from pkgs, so
  # we get the right path in the sudo config
  environment.systemPackages = [ pkgs.nixos-rebuild ];
  security.sudo.extraRules = [
    {  users = [ "ohm" ];
      commands = [
      { command = "${pkgs.nixos-rebuild}/bin/nixos-rebuild";
          options = [ "NOPASSWD" "SETENV" ];
          }
          { command = "/run/current-system/sw/bin/nixos-rebuild";
            options = [ "NOPASSWD" "SETENV" ];
          }
          { command = "${pkgs.systemd}/bin/systemctl";
            options = [ "NOPASSWD" "SETENV" ];
          }
          # reboot and shutdown are symlinks to systemctl,
          # but need to be authorized in addition to the systemctl binary
          # to allow nopasswd sudo
          { command = "/run/current-system/sw/bin/shutdown";
            options = [ "NOPASSWD" "SETENV" ];
          }
          { command = "/run/current-system/sw/bin/reboot";
            options = [ "NOPASSWD" "SETENV" ];
          }           
          ];
        }
    ];
}

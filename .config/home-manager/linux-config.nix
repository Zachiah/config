{ config, pkgs, lib, ... }:

let
  isLinux = pkgs.stdenv.isLinux;
in
{
    config = lib.mkIf isLinux {
        home.sessionVariables = {
            XDG_CURRENT_DESKTOP = "sway"; 
        };

        wayland.windowManager.sway = {
            enable = true;
            config = rec {
                modifier = "Mod4";
                terminal = "alacritty";
                startup = [
                    { command = "swaybg -i ~/Downloads/dark-bg-1.jpg -m fill"; }
                ];
            };
            extraConfig = ''
              bindswitch lid:on output eDP-2 disable
              bindswitch lid:off output eDP-2 enable
              exec systemctl --user import-environment
            '';
        };

        home.packages = [
            pkgs.wpa_supplicant_gui
            pkgs.wl-clipboard
            pkgs.swaylock
            pkgs.swayidle
            pkgs.grim
            pkgs.slurp
            pkgs.bemenu
            pkgs.mako
            pkgs.wdisplays
            pkgs.helvum
            pkgs.pavucontrol
            pkgs.swaybg
            pkgs.blueman
            pkgs.bluez
            pkgs.protonmail-bridge
            pkgs.gcc
            pkgs.pciutils
            pkgs.lshw
            pkgs.shutter
            pkgs.polychromatic
        ];
    };
}

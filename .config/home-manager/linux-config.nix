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
              client.focused #172554 #172554 #FFFFFF
              gaps inner 10
              bar {
                  swaybar_command waybar
              }
            '';
        };

        programs.waybar = {
            enable = true;
            settings = {
                mainBar = {
                    position = "top";
                    layer = "bottom";
                    spacing = 10;
                    margin = "10px";
                    modules-left = ["clock" "battery" ];
                    modules-right = ["sway/workspaces"];
                    modules-center = ["network"];
                    clock = {
                        format = "{:%I:%M}  ";
                    };
                    battery = {
                        format = "{capacity}% {icon}";
                        format-icons = ["" "" "" "" ""];
                    };
                    network = {
                        format-wifi = "{essid} ({signalStrength}%) ";
                        format-disconnected = "Disconnected";
                    };
                };
            };
            style = ''
                window {
                    padding: 10px;
                    margin-bottom: 10px;
                    color: white;
                    background-color: #172554;
                    border-radius: 8px;
                }
                .modules-left, .modules-center, .modules-right {
                    padding: 10px;
                }
                #clock {
                    margin-left: 5px;
                }
                #clock, #battery, #network, #workspaces {
                    padding: 5px 10px;
                    color: #172554;
                    background-color: white;
                    border-radius: 5px;
                }
                #battery, #network {
                    padding-right: 20px;
                }
                #workspaces button {
                    transition-duration: 500ms;
                    transition-property: background-color, color;
                }
                #workspaces button:hover {
                    background-color: gray;
                }
                #workspaces button.focused {
                    background-color: #172554;
                    color: white;
                }
                #workspaces button.urgent {
                    background-color: #450a0a;
                    color: white;
                }
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

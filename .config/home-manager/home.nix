{ config, pkgs, ... }:

{
    home.username = builtins.getEnv "USER";
    home.homeDirectory = builtins.getEnv "HOME";
    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    #
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.
    home.stateVersion = "23.11"; # Please read the comment before changing.

    gtk = {
        enable = true;
        theme = {
            name = "Catppuccin-Macchiato-Compact-Pink-Dark";
            package = pkgs.catppuccin-gtk.override {};
        };
    };
    home.packages = [
        pkgs.neofetch
        pkgs.tree-sitter
        pkgs.rustup

        pkgs.nodePackages.pnpm
        pkgs.twilio-cli

        pkgs.nodejs_20
        pkgs.spotify
        pkgs.discord
        pkgs.github-cli
        pkgs.ripgrep
        pkgs.kitty
        pkgs.alacritty
        pkgs.spotify-tui
        pkgs.vscode
        pkgs.nerdfonts
        
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
        pkgs.thunderbird
    ];

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

    # Home Manager is pretty good at managing dotfiles. The primary way to manage
    # plain files is through 'home.file'.
    home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
    };

    home.sessionVariables = {
      XDG_CURRENT_DESKTOP = "sway"; 
    };

    home.shellAliases = {
        config = "git --git-dir=$HOME/.cfg/ --work-tree=$HOME";
    };

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
    programs.neovim.enable = true;
    programs.tmux.enable = true;
    programs.git.enable = true;
    programs.zsh = {
        enable = true;
        oh-my-zsh = {
            enable = true;
            plugins = ["git"];
            theme = "cloud";
        };
        initExtra = ''
            source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
        '';
    };
    programs.firefox.enable = true;

    nixpkgs.config.allowUnfree = true;
}

#eval TWILIO_AC_ZSH_SETUP_PATH=/Users/zachiahsawyer/.twilio-cli/autocomplete/zsh_setup && test -f $TWILIO_AC_ZSH_SETUP_PATH && source $TWILIO_AC_ZSH_SETUP_PATH; # twilio autocomplete setup

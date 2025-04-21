{ config, pkgs, lib, ... }:

{
    imports = [./linux-config.nix];

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
        pkgs.github-cli
        pkgs.ripgrep
        pkgs.kitty
        pkgs.alacritty
        pkgs.vscode
        pkgs.thunderbird
        pkgs.figlet
        pkgs.htop
        pkgs.cmatrix
        pkgs.gopls
        pkgs.typescript
        pkgs.lua-language-server
    ];

    # Home Manager is pretty good at managing dotfiles. The primary way to manage
    # plain files is through 'home.file'.
    home.file = {};


    home.shellAliases = {
        config = "git --git-dir=$HOME/.cfg/ --work-tree=$HOME";
    };

    home.sessionPath = [
        "/home/zachiahsawyer/.cargo/bin"
    ];

    programs.home-manager.enable = true;
    programs.neovim.enable = true;
    programs.tmux = {
        enable = true;
        extraConfig = ''
            # Switch panes with Vim keys
            bind -r k select-pane -U
            bind -r j select-pane -D
            bind -r h select-pane -L
            bind -r l select-pane -R
            set -g repeat-time 50 
        '';
    };
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
        profileExtra = lib.optionalString (config.home.sessionPath != [ ]) ''
          export PATH="$PATH''${PATH:+:}${lib.concatStringsSep ":" config.home.sessionPath}"
        '';

    };
    programs.go = {
        enable = true;
    };

    nixpkgs.config.allowUnfree = true;
    nixpkgs.overlays =
      let
        # Change this to a rev sha to pin
        moz-rev = "master";
        moz-url = builtins.fetchTarball { url = "https://github.com/mozilla/nixpkgs-mozilla/archive/${moz-rev}.tar.gz";};
        nightlyOverlay = (import "${moz-url}/firefox-overlay.nix");
      in [
        nightlyOverlay
      ];
}


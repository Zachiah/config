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
    home.stateVersion = "23.05"; # Please read the comment before changing.

    home.packages = [
        pkgs.neofetch
        pkgs.tree-sitter
        pkgs.rustup

        pkgs.nodePackages.pnpm
        pkgs.twilio-cli

        pkgs.nodejs_20
        pkgs.spotify
        pkgs.discord
        pkgs.gh
        pkgs.ripgrep
        pkgs.alacritty

        # I'm sorry but sometimes it has to be ):
        pkgs.vscode

        # # It is sometimes useful to fine-tune packages, for example, by applying
        # # overrides. You can do that directly here, just don't forget the
        # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
        # # fonts?
        # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

        # # You can also create simple shell scripts directly inside your
        # # configuration. For example, this adds a command 'my-hello' to your
        # # environment:
        # (pkgs.writeShellScriptBin "my-hello" ''
        #   echo "Hello, ${config.home.username}!"
        # '')
    ];

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

    # You can also manage environment variables but you will have to manually
    # source
    #
    #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
    #
    # or
    #
    #  /etc/profiles/per-user/zaciahsawyer/etc/profile.d/hm-session-vars.sh
    #
    # if you don't want to manage your shell through Home Manager.
    home.sessionVariables = {
        # EDITOR = "emacs";
    };

    home.shellAliases = {
        config = "/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME";
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
    nixpkgs.config.allowUnfree = true;
}

#eval TWILIO_AC_ZSH_SETUP_PATH=/Users/zachiahsawyer/.twilio-cli/autocomplete/zsh_setup && test -f $TWILIO_AC_ZSH_SETUP_PATH && source $TWILIO_AC_ZSH_SETUP_PATH; # twilio autocomplete setup

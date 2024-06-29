{ pkgs, pkgs-master, ... }:
{
  # hide entries
  xdg.desktopEntries = {
    "ranger" = {
      name = "ranger";
      noDisplay = true;
    };
  };

  home.packages = with pkgs; with nodePackages_latest; with gnome; [
    # colorscript
    (import ./colorscript.nix { inherit pkgs; })

    # gui
    (mpv.override { scripts = [mpvScripts.mpris]; })
    libreoffice
    caprine-bin
    d-spy
    easyeffects
    github-desktop
    gimp
    transmission_4-gtk
    discord
    bottles
    teams-for-linux
    icon-library
    dconf-editor
    slack
    # temporary override while upstream fixes itself
    (google-chrome.override {
      commandLineArgs = [
        "--enable-features=UseOzonePlatform"
        "--ozone-platform=wayland"
      ];
    })

    # tools
    bat
    eza
    ranger
    fd
    ripgrep
    fzf
    socat
    jq
    acpi
    inotify-tools
    ffmpeg
    libnotify
    killall
    zip
    unzip
    glib
    lazygit
    tailwindcss-language-server

    #devenv
    pkgs-master.devenv

    # language servers 
    marksman
    lua-language-server
    nodePackages.bash-language-server
    tailwindcss-language-server
    nil
    terraform-lsp
    ruff-lsp

    # formatters
    stylua
  ];
}

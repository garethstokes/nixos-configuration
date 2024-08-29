{ pkgs, pkgs-master, ... }:
let 
  opencommit = pkgs.buildNpmPackage rec {
    pname = "opencommit";
    version = "3.0.16";
    src = pkgs.fetchFromGitHub {
      owner = "di-sukharev";
      repo = "opencommit";
      rev = "v${version}";
      hash = "sha256-whzQrpwISZL5s6TYoDh8BraLjx52tE1DPFG0LNmsrZk=";
    };
    npmDepsHash = "sha256-Oq0WnIeEVJk84yH1hpZU45rKEYQZtKbFWeIrJ51p+ec=";
  };
in
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
    pkgs.dconf-editor
    slack
    evolution
    dbeaver-bin
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
    opencommit
    ollama

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

{ pkgs, username, ... }:
let
  homeDirectory = "/home/${username}";
in
{
  imports = [
    ./browser.nix
    ./bspwm.nix
    ./dconf.nix
    ./git.nix
    ./neofetch.nix
    ./neovim.nix
    ./packages.nix
    ./sh.nix
    ./starship.nix
    ./theme.nix
    ./tmux.nix
    ./kitty.nix
  ];

  news.display = "show";

  targets.genericLinux.enable = true;

  # nix = {
  #   package = pkgs.nix;
  #   settings = {
  #     experimental-features = [ "nix-command" "flakes" ];
  #     warn-dirty = false;
  #   };
  # };
  
  catppuccin.flavor = "mocha";

  home = {
    inherit username homeDirectory;

    sessionVariables = {
      NIXPKGS_ALLOW_UNFREE = "1";
      SHELL = "${pkgs.zsh}/bin/zsh";
      BAT_THEME = "base16";
    };

    sessionPath = [
      "$HOME/.local/bin"
    ];
  };

  programs.spotify-player.enable = true;
  programs.home-manager.enable = true;
  home.stateVersion = "21.11";
}

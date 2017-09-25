# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "/dev/sda";
  };

  networking = {
    hostName = "hax0r";
    wireless.enable = true;
  };

  # Select internationalisation properties.
  i18n = {
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "Australia/Sydney";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    wget
    vim
    neovim
    gitAndTools.gitFull
    iptables nmap tcpdump
    rxvt_unicode
    zlib
    bc
    unzip
    zsh

    chromium
    firefoxWrapper

    gcc
    binutils

    xfontsel
    xlsfonts
    xscreensaver
  ] ++ (with haskellPackages; [
    ghc
    xmobar
    xmonad
    xmonad-contrib
    xmonad-extras
  ]);

  nixpkgs.config = {
    allowUnfree = true;
   
    chromium = {
      enablePepperFlash = true;
      enablePepperPDF = true;
    };
  };

  programs = {
    bash.enableCompletion = true;
    zsh.enable = true;
  };

  environment.sessionVariables = {
    EDITOR = "nvim";
    NIXPKGS_ALLOW_UNFREE = "1";

    shells = [
      "${pkgs.zsh}/bin/zsh"
    ];
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "us";
    
    windowManager = {
      xmonad.enable = true;
      xmonad.enableContribAndExtras = true;
      default = "xmonad";
    };

    desktopManager = {
      xterm.enable = true;
      default = "none";
    };

    displayManager = {
      slim = {
        enable = true;
        defaultUser = "gareth";
	theme = pkgs.fetchurl {
	  url = "https://github.com/edwtjo/nixos-black-theme/archive/v1.0.tar.gz";
	  sha256 = "13bm7k3p6k7yq47nba08bn48cfv536k4ipnwwp1q1l2ydlp85r9d";
	  };
      };
    };

  };

  services.postgresql.enable = true;

  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      anonymousPro
      corefonts
      dejavu_fonts
      font-droid
      freefont_ttf
      google-fonts
      inconsolata
      liberation_ttf
      powerline-fonts
      source-code-pro
      terminus_font
      ttf_bitstream_vera
      ubuntu_font_family
    ];
  };


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.gareth = {
    isNormalUser = true;
    uid = 1000;
    name = "gareth";
    extraGroups = [ "wheel" "disk" "audio" "video" "networkmanager" "systemd-journal" ];
    createHome = true;
    home = "/home/gareth";
  };

  security.sudo.enable = true;

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "17.03";

}

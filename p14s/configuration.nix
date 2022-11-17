# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec "$@"
  '';
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nixpkgs.config.allowUnfree = true;

  nix = {
    package = pkgs.nixVersions.stable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    settings.trusted-users = [ "root" "gareth" ];
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest.extend (self: super: {
    evdi = super.evdi.overrideAttrs (o: rec {
      src = pkgs.fetchFromGitHub {
        owner = "DisplayLink";
        repo = "evdi";
        rev = "bdc258b25df4d00f222fde0e3c5003bf88ef17b5";
        sha256 = "mt+vEp9FFf7smmE2PzuH/3EYl7h89RBN1zTVvv2qJ/o=";
      };
    });
  });
  # boot.kernelParams = [ "module_blacklist=i915" ];

  networking.hostName = "bandit"; # Define your hostname.

  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;
  hardware.enableRedistributableFirmware = true;

  hardware.nvidia = {
    # package = config.boot.kernelPackages.nvidiaPackages.legacy_470;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    # open = true;

    modesetting.enable = true;

    powerManagement.enable = true;
    powerManagement.finegrained = true;

    prime = {
      offload.enable = true;
      # sync.enable = true;
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:3:0:0";
    };
  };


  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
  };

  fonts.fonts = with pkgs; [
    fira-code
    fira-code-symbols
  ];

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Set your time zone.
  time.timeZone = "Australia/Sydney";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment = {
    variables = {
      EDITOR = "vim";
    };

    systemPackages = with pkgs; [
      wget
      nvidia-offload

      # basic vim base install
      (neovim.override {
        vimAlias = true;
        configure = {
          packages.myPlugins = with pkgs.vimPlugins; {
            start = [ vim-lastplace vim-nix ]; 
            opt = [];
          };
          customRC = ''
            set expandtab|retab
            set tabstop=2
            set shiftwidth=2
            set list
            set nu
            set colorcolumn=80
            set mouse=a
            syntax enable
          '';
        };
      })
    ];

    gnome = {
      excludePackages = (with pkgs; [
        gnome-photos
        gnome-tour
      ]) ++ (with pkgs.gnome; [
        cheese # webcam tool
        gnome-music
        gnome-terminal
        gedit # text editor
        epiphany # web browser
        geary # email reader
        evince # document viewer
        gnome-characters
        totem # video player
        tali # poker game
        iagno # go game
        hitori # sudoku game
        atomix # puzzle game
      ]);
    };
  };

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  # hardware.pulseaudio.package = pkgs.pulseaudioFull;

  services.autorandr.enable = true;

  services.xserver = {
    enable = true;
    layout = "us";
    xkbOptions = "eurosign:e";

    # Video
    videoDrivers = [ "nvidia" "displaylink" ];

    libinput = {
      enable = true;

      touchpad = {
        # enables tap-to-click behavior
        tapping = true;

        naturalScrolling = true;

        # both button pressed will emulate a middle button click
        middleEmulation = true;
      };
    };

    # Enable the Gnome Desktop Environment.
    displayManager = {
      defaultSession = "gnome";
      gdm = {
        enable = true;
        wayland = true;
      };
      autoLogin = {
        enable = true;
        user = "gareth";
      };
    };

    desktopManager.gnome = {
      enable = true;
    };
  };


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    defaultUserShell = pkgs.zsh;
    users.gareth = {
      isNormalUser = true;
      extraGroups = [ "wheel" "docker" ]; # Enable ‘sudo’ for the user.
    };
  };

  # PostgreSQL server for development purposes.
  # Accepts connections on 127.0.0.1 with "postgres" user
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_14;
    authentication = pkgs.lib.mkForce ''
      # TYPE  DATABASE        USER            ADDRESS                 METHOD
      local   all             all                                     trust
      host    all             all             127.0.0.1/32            trust
      host    all             all             ::1/128                 trust
    '';
    initialScript = pkgs.writeText "backend-initScript" ''
      mkdir -p /var/log/postgresql
    '';
    settings = {
      log_connections = true;
      log_statement = "all";
      logging_collector = true;
      log_disconnections = true;
      log_destination = pkgs.lib.mkForce "stderr";
      log_directory = "/var/log/postgresql";
    };
  };

  # Docker
  virtualisation.docker.enable = true;

  # adjust screen brightness
  programs.light.enable = true;

  # Power
  services.power-profiles-daemon.enable = false;
  services.logind = {
    lidSwitch = "ignore";
  };

  # firmware updater
  services.fwupd.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.03"; # Did you read the comment?

}

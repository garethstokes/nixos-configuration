# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, username, hostname, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.nvidia.acceptLicense = true;

  nix = {
    package = pkgs.nixVersions.stable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    settings.trusted-users = [ "root" "gareth" ];
  };

  # Use the systemd-boot EFI boot loader.
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = ["i2c-dev"];

    # https://download.nvidia.com/XFree86/Linux-x86_64/435.17/README/powermanagement.html
    # kernelParams = [ "nvidia.NVreg_PreserveVideoMemoryAllocations=1" ];

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;

      grub = {
        efiSupport = true;
        device = "nodev";
      };
    };
  }; 

  networking.hostName = hostname; # Define your hostname.

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.enableRedistributableFirmware = true;

  hardware.nvidia = {
    # package = config.boot.kernelPackages.nvidiaPackages.beta;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    open = false;
    nvidiaSettings = false;
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = true;

    prime = {
      offload.enable = true;
      offload.enableOffloadCmd = true;
      # sync.enable = true;
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:3:0:0";
    };
  };


  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
  };

  fonts = {
    # enableDefaultPackages = true;
    packages = with pkgs; [
      fira-code
      fira-code-symbols
      font-awesome
    ];
  };

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

    sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };

    systemPackages = with pkgs; [
      wget
      ddcutil
      home-manager

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
        evince # document viewer
        gnome-characters
        totem # video player
      ]);
    };
  };

  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        # xdg-desktop-portal-gtk
      ];
    };
  };

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
  };

  # bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings.General.Experimental = true; # for gnome-bluetooth percentage
    settings.General.ControllerMode = "bredr";
  };

  services.autorandr.enable = true;

  # antivirus for comliance
  # services.clamav = {
  #   daemon.enable = true;
  #   updater.enable = true;
  # };
  

  services = {
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
  };

  services.xserver = {
    enable = true;
    xkb.layout = "us";
    xkb.options = "eurosign:e";

    # Video
    videoDrivers = [ "nvidia" "displaylink" ];

    # Enable the Gnome Desktop Environment.
    displayManager = {
      gdm = {
        enable = true;
        wayland = true;
      };
      # autoLogin = {
      #   enable = true;
      #   user = "gareth";
      # };
    };

    desktopManager.gnome = {
      enable = true;
    };
  };

  programs = {
    zsh.enable = true;

    # adjust screen brightness
    light.enable = true;

    dconf.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    defaultUserShell = pkgs.zsh;
    users."${username}" = {
      isNormalUser = true;
      extraGroups = [ "wheel" "docker" ]; # Enable ‘sudo’ for the user.
    };

    extraGroups.vboxusers.members = [ "${username}" ];
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
  virtualisation = {
    docker.enable = true;
    libvirtd.enable = true;
    podman.enable = true;
  };

  # Power
  services.power-profiles-daemon.enable = false;
  services.logind = {
    lidSwitch = "ignore";
    extraConfig = ''
      HandlePowerKey=ignore
      HandleLidSwitch=suspend
      HandleLidSwitchExternalPower=ignore
    '';
  };

  # firmware updater
  services.fwupd.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

}

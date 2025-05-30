# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader = {
    #systemd-boot.enable = true; # Use systemd-boot instead of GRUB.
    efi.canTouchEfiVariables = true;
    grub = {
      enable = true; # Enable GRUB bootloader.
      devices = [ "nodev" ]; # Install GRUB on the first disk.
      efiSupport = true; # Enable UEFI support.
      useOSProber = true; # Enable if you want to detect other OSes.
    };
  };

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Istanbul";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "tr_TR.UTF-8";
    LC_IDENTIFICATION = "tr_TR.UTF-8";
    LC_MEASUREMENT = "tr_TR.UTF-8";
    LC_MONETARY = "tr_TR.UTF-8";
    LC_NAME = "tr_TR.UTF-8";
    LC_NUMERIC = "tr_TR.UTF-8";
    LC_PAPER = "tr_TR.UTF-8";
    LC_TELEPHONE = "tr_TR.UTF-8";
    LC_TIME = "tr_TR.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  #Excluding GNOME Applications
  environment.gnome.excludePackages = with pkgs; [
    #orca
    evince
    file-roller
    geary
    gnome-disk-utility
    seahorse
    # sushi
    # sysprof
    # gnome-shell-extensions
    # adwaita-icon-theme
    # nixos-background-info
    # gnome-backgrounds
    # gnome-bluetooth
    # gnome-color-manager
    # gnome-control-center
    gnome-tour # GNOME Shell detects the .desktop file on first log-in.
    # gnome-user-docs
    # glib # for gsettings program
    # gnome-menus
    # gtk3.out # for gtk-launch program
    # xdg-user-dirs # Update user dirs as described in https://freedesktop.org/wiki/Software/xdg-user-dirs/
    # xdg-user-dirs-gtk # Used to create the default bookmarks
    #
    # baobab
    epiphany
    # gnome-text-editor
    gnome-calculator
    gnome-calendar
    # gnome-characters
    gnome-clocks
    # gnome-console
    gnome-contacts
    gnome-font-viewer
    # gnome-logs
    gnome-maps
    gnome-music
    # gnome-system-monitor
    gnome-weather
    # loupe
    # nautilus
    gnome-connections
    simple-scan
    #snapshot
    totem
    #yelp
    #gnome-software
  ];

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "tr";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "trq";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.fcen = {
    isNormalUser = true;
    description = "fcen";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker" # Add user to the "docker" group to run docker without sudo
    ];
    packages = with pkgs; [
      #  thunderbird
    ];
  };
  
  # Enable Docker Support
  virtualisation.docker.enable= true; 

  # for global user
  users.defaultUserShell = pkgs.zsh;
  # For a specific user
  users.users.fcen.shell = pkgs.zsh;

  # Install firefox.
  #programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  hardware.graphics.enable = true; # Enable graphics hardware support.
  hardware.graphics.enable32Bit = true; # Enable 32-bit graphics support (if needed).

  services.xserver.videoDrivers = [ "nvidia" ]; # Use the NVIDIA driver for graphics.
  hardware.nvidia.modesetting.enable = true; # Enable modesetting for NVIDIA.
  hardware.nvidia.open = false;
  hardware.nvidia.prime = {
    # Enable NVIDIA PRIME support for hybrid graphics systems.
    offload = {
      enable = true; # Enable offloading support.
      enableOffloadCmd = true; # Lets you use `nvidia-offload %command%` in steam
    };

    intelBusId = "PCI:00:02:0"; # Set the Intel GPU bus ID.
    # amdgpuBusId = "PCI:0:0:0";
    nvidiaBusId = "PCI:01:00:0"; # Set the NVIDIA GPU bus ID.
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages =
    with pkgs;
    [
      #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
      nixfmt-rfc-style # offical one, Formatter (optional: you can use alejandra instead) also there
      wget
      zsh
      zsh-autosuggestions
      zsh-syntax-highlighting
      fastfetch
      htop
      git
      nodejs_22
      pnpm
      bun
      jdk17
      gcc
      docker_28
      python313
      android-studio
      vscode
      brave
      thunderbird
      stremio
      discord
      spotify
      vlc

    ]
    ++ (with pkgs.gnomeExtensions; [
      # GNOME Extensions
      caffeine
      clipboard-indicator
      dash-to-dock
    ]);

  services.flatpak.enable = true;
  systemd.services.flatpak-repo = {
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableBashCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    histSize = 1000; # Increase history size

    ohMyZsh = {
      enable = true;
      plugins = [ "git" ];
    };
    interactiveShellInit = ''
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
    '';
    promptInit = "";
  };

  fonts.packages = with pkgs; [
  noto-fonts
  noto-fonts-cjk-sans
  noto-fonts-emoji
  liberation_ttf
  fira-code
  fira-code-symbols
  nerd-fonts.fira-code
  jetbrains-mono
  nerd-fonts.jetbrains-mono
  nerd-fonts.droid-sans-mono
  dina-font
  proggyfonts
];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}

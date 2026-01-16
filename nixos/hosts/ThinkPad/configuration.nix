# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{ imports = [ ];
  
  hardware.bluetooth = { enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true;
        FastConnectable = true;
      };
    };
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "ThinkPad"; 
  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  networking.firewall = { 
    enable = true;
    allowedTCPPorts = [ 8787 ];
    allowedTCPPortRanges = [ 
      { from = 1714; to = 1764; } # KDE Connect
    ];  
    allowedUDPPortRanges = [ 
      { from = 1714; to = 1764; } # KDE Connect
    ];  
  };  

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.powersave = false;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";
  
  # Enable Docker
  virtualisation.docker.enable = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  services.static-web-server = {
    enable = true;
    root = "/home/felix/Webserver/";
    configuration = {
      general = {
        directory-listing = true;
      };
    };
  };

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm = {
    enable = true;
    theme = "Elegant";
  };
  services.desktopManager.plasma6.enable = true;

  # Mullvad
  services.mullvad-vpn = {
    enable = true;
    package = pkgs.mullvad-vpn;
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "de";
    variant = "nodeadkeys";
  };

  # Configure console keymap
  console.keyMap = "de-latin1-nodeadkeys";

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
  users.users.felix = {
    shell = pkgs.zsh;
    isNormalUser = true;
    home = "/home/felix";
    description = "Felix Busch";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
      pkgs.zsh-powerlevel10k
      kdePackages.kate
      pkgs.kdePackages.kdeconnect-kde
      pkgs.kdePackages.sddm-kcm
      pkgs.libreoffice
      pkgs.obsidian
      pkgs.remmina
      # pkgs.steam
      # thunderbird
    ];
  };

  programs.firefox.enable = true;

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  programs.nvf = {
    enable = true;
    settings = {
      vim = {
        lsp.enable = true;
        ui = {
          borders.enable = true;
          colorizer.enable = true;
        };
        theme = {
          enable = true;
          name = "everforest";
          style = "hard";
        };

        statusline.lualine = {
          enable = true;
          theme = "everforest";
        };

        telescope.enable = true;
        autocomplete.nvim-cmp.enable = true;

        languages = {
          enableTreesitter = true;

          nix.enable = true;
          ts.enable = true;
          rust.enable = true;
          bash.enable = true;
          python.enable = true;
        };
      };
    };
  };

  programs.zsh = {
    enable = true;
    promptInit = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
        nixrb = "sudo nixos-rebuild switch --flake /etc/nixos#ThinkPad";
	nixcfg = "sudo nvim /etc/nixos/";
	homecfg = "sudo nvim /etc/nixos/hosts/ThinkPad/home.nix";
	flakecfg = "sudo nvim /etc/nixos/flake.nix";
        work = "nix-shell /home/felix/Shells/Networking/networking.nix";
        webs = "nix-shell /home/felix/Shells/Networking/webserver.nix";
        vpnup = "sudo openvpn --config /home/felix/Downloads/VPNs/pfSense-UDP4-1194-f.busch-config.ovpn";
    };
  };
  

  programs.zsh.ohMyZsh = {
    enable = true;
    plugins = [ "git" "sudo" "docker" "colorize" "tmux" ];
    # theme = "powerlevel10k/powerlevel10k";
  };

  programs.steam.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Allow nix command and flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
	pkgs.winboat
	pkgs.bat
	pkgs.kitty
	pkgs.brave
	pkgs.git
	pkgs.gh
	pkgs.zsh
	pkgs.prismlauncher
        pkgs.fastfetch
	pkgs.zsh-powerlevel10k
	pkgs.neovim
        pkgs.elegant-sddm
        pkgs.quickshell
        pkgs.noctalia-shell
        pkgs.spotify
	eza
	vim
  ];
  
  fonts.packages = with pkgs; [
    nerd-fonts.hurmit
    nerd-fonts.jetbrains-mono
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:
    
    services.tailscale.enable = true;

    services.ollama = {
      enable = true;
      loadModels = [ "llama3.2:3b" "deepseek-r1:1.5b"];
      # acceleration = "vulkan";
    };
    
    # services.openssh = {
    #   enable = true;
    #   settings = {
    #     PasswordAuthentication = true;
    #     PermitRootLogin = "yes";
    #   };
    # };

  system.stateVersion = "25.11"; # Did you read the comment?

}

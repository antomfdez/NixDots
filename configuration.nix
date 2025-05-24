# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
    imports =
        [ # Include the results of the hardware scan.
            ./hardware-configuration.nix
        ];

    # Bootloader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    boot.initrd.luks.devices."luks-f8a4cb2e-5f61-40ab-9f67-6ed18563c3d2".device = "/dev/disk/by-uuid/f8a4cb2e-5f61-40ab-9f67-6ed18563c3d2";
    networking.hostName = "nixos"; # Define your hostname.
    # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    programs.spicetify =
        let
            spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
        in
            {
            enable = true;

            enabledExtensions = with spicePkgs.extensions; [
                adblock
                hidePodcasts
                autoVolume
                volumePercentage
                groupSession
            ];
            enabledCustomApps = with spicePkgs.apps; [
                newReleases
            ];
            enabledSnippets = with spicePkgs.snippets; [
                rotatingCoverart
                pointer
            ];

            theme = spicePkgs.themes.nightlight;
            #colorScheme = "mocha";
        };
    # Enable networking
    networking.networkmanager.enable = true;

    # Set your time zone.
    time.timeZone = "Europe/Madrid";

    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";

    i18n.extraLocaleSettings = {
        LC_ADDRESS = "es_ES.UTF-8";
        LC_IDENTIFICATION = "es_ES.UTF-8";
        LC_MEASUREMENT = "es_ES.UTF-8";
        LC_MONETARY = "es_ES.UTF-8";
        LC_NAME = "es_ES.UTF-8";
        LC_NUMERIC = "es_ES.UTF-8";
        LC_PAPER = "es_ES.UTF-8";
        LC_TELEPHONE = "es_ES.UTF-8";
        LC_TIME = "es_ES.UTF-8";
    };

    # Enable the X11 windowing system.
    #services.xserver.enable = true;

    # Enable the XFCE Desktop Environment.
    services.xserver.displayManager.lightdm.enable = true;

    #services.xserver.desktopManager.xfce.enable = true;

    services.displayManager = {
        defaultSession = "none+i3";
    };

    services.xserver = {
        enable = true;

        desktopManager = {
            xterm.enable = false;
        };


        windowManager.i3 = {
            enable = true;
            extraPackages = with pkgs; [
                dmenu #application launcher most people use
                i3status # gives you the default i3 status bar
                i3lock #default i3 screen locker
                i3blocks #if you are planning on using i3blocks over i3status
            ];
        };
    };
    services.picom = {
        enable = true;
        vSync = true;
    };

    # Configure keymap in X11
    services.xserver.xkb = {
        layout = "us";
        variant = "alt-intl";
    };

    # Configure console keymap
    console.keyMap = "us";

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

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.antom = {
        isNormalUser = true;
        description = "antom";
        extraGroups = [ "networkmanager" "wheel" "audio" "video" ];
        packages = with pkgs; [
            #  thunderbird
        ];
        shell = pkgs.zsh;
    };

    security.sudo.enable = true;
    security.sudo.extraRules = [
        {
            users = [ "antom" ];
            commands = [
                {
                    command = "ALL";
                    options = [ "NOPASSWD" ];
                }
            ];
        }
    ];

    # Enable
    programs.firefox.enable = true;
    programs.zsh.enable = true;
    services.printing.enable = true;
    services.libinput.enable = true;

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;
    networking.extraHosts = ''
  #  10.10.11.68   planning.htb
  #  192.168.1.10 server.local
    '';

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment.systemPackages = with pkgs; [
	fzf
        pfetch-rs
        floorp
        gh
        burpsuite
        luarocks
        delve
        lua-language-server
        lua5_1
        gcc
        git
        picom
        vivaldi
        vim
        neovim
        ghostty
        networkmanagerapplet
        brightnessctl
        pavucontrol
        pulseaudio
        nwg-look
        dunst
        libnotify
        font-awesome_5
        sysstat
        alsa-utils
        lm_sensors
        acpi
        keepassxc
        feh
        fastfetch
        flameshot
        equibop
        tmux
        qemu
        openvpn
        spotify
    ];
    fonts.packages = with pkgs; [
        nerd-fonts.jetbrains-mono
        nerd-fonts.fantasque-sans-mono
        nerd-fonts.ubuntu
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
    system.stateVersion = "24.11"; # Did you read the comment?

}

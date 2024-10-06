# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
       <catppuccin/modules/nixos>
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  networking = {
    hostName = "zena-pc"; # Define your hostname.
    networkmanager.enable = true;  # Easiest to use and most distros use this by default.

    # Open ports in the firewall.
    firewall = {
      allowedTCPPorts = [80 420 57621];
      allowedUDPPorts = [ 5353 ];
    };

    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  };

  # Set your time zone.
  time.timeZone = "Europe/Prague";


  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true; # use xkb.options in tty.
  };

  services = {
    openssh.enable = true;
    displayManager.sddm = {
	package = pkgs.kdePackages.sddm;
	enable = true;
    };
    pipewire = {
      enable = true;
      pulse.enable = true;
    };
    xserver = {
      enable = true;
      desktopManager.plasma5.enable = true;

      xkb.layout = "cz"; 
      xkb.options = "eurosign:e,caps:escape";
    };
    dbus.packages = [ pkgs.blueman ];
    blueman.enable = true;
  };



  users.users.loading = {
    isNormalUser = true;
    extraGroups = [ "wheel" "nixos" ]; # Enable ‘sudo’ for the user.
    openssh.authorizedKeys.keys = [
      # "ssh-rsa AAAAB3Nz....6OWM= user" # content of authorized_keys file
    ];
    packages = with pkgs; [
      firefox
      tree
      kitty
      steam
      discord
      (discord.override {
        withVencord = true;
      })
      lutris

      catppuccin
      catppuccin-kde
      libreoffice

      jetbrains.clion
      jetbrains.rider
      jetbrains.idea-ultimate
   
      spotify
      github-desktop
      gh
      git-credential-manager
 ];
    shell = pkgs.zsh;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim 
    wget
    curl
    git
    zoxide
    zsh
    pfetch-rs
    sselp
    wacomtablet

    gcc
    rustc
    cargo
    python3
    acpi
    gnomeExtensions.upower-battery
    pavucontrol
    alsa-tools
    blueman 
    gnomeExtensions.duckduckgo-search-provider
    openssh
 ];

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  programs = {
    steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    };
   mtr.enable = true;
   gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
   };
   zsh.enable = true;
  };
  catppuccin.enable = true;


  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.11"; # Did you read the comment?
}

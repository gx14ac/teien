{ inputs, pkgs, ... }:

{
  # Set in Apr 2026 as part of the macOS Sequoia release.
  system.stateVersion = 5;

  # This makes it work with the Determinate Nix installer
  ids.gids.nixbld = 30000;

  # We use proprietary software on this machine
  nixpkgs.config.allowUnfree = true;

  # Nix configuration
  nix = {
    # We use the determinate-nix installer which manages Nix for us,
    # so we don't want nix-darwin to do it.
    enable = false;

    # Enable flakes
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    '';

    # Enable the Linux builder so we can run Linux builds on our Mac.
    # This can be debugged by running `sudo ssh linux-builder`
    linux-builder = {
      enable = false;
      ephemeral = true;
      maxJobs = 4;
      config = ({ pkgs, ... }: {
        # Make our builder beefier since we're on a beefy machine.
        virtualisation = {
          cores = 6;
          darwin-builder = {
            diskSize = 100 * 1024; # 100GB
            memorySize = 32 * 1024; # 32GB
          };
        };

        # Add some common debugging tools
        environment.systemPackages = [
          pkgs.htop
        ];
      });
    };

    settings = {
      # Optional: Use your own binary cache here
      # substituters = ["https://your-cache.cachix.org"];
      # trusted-public-keys = ["your-cache.cachix.org-1:..."];

      # Required for the linux builder
      trusted-users = ["@admin"];
    };
  };

  # Shell configuration
  programs.zsh.enable = true;
  programs.zsh.shellInit = ''
    # Nix
    if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
      . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
    fi
    # End Nix
  '';

  programs.fish.enable = true;
  programs.fish.shellInit = ''
    # Nix
    if test -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish'
      source '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish'
    end
    # End Nix
  '';

  environment.shells = with pkgs; [ bashInteractive zsh fish ];
  environment.systemPackages = with pkgs; [
    # Add any macOS-specific packages here
  ];

  # Homebrew configuration
  homebrew = {
    enable = true;

    # GUI applications installed via Homebrew Cask
    casks = [
      "1password"
      "claude"
      "discord"
      "google-chrome"
      "iterm2"
      "raycast"
      "rectangle"
      "slack"
      "spotify"
      "visual-studio-code"
      "ghostty"
    ];

    # CLI tools installed via Homebrew
    brews = [
      "gnupg"
    ];

    # Auto-update and auto-upgrade
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };
  };

  # User configuration
  users.users.snt = {
    home = "/Users/snt";
    shell = pkgs.fish;
  };

  # Required for some settings like homebrew
  system.primaryUser = "snt";

  # macOS system settings
  system.defaults = {
    dock = {
      autohide = true;
      orientation = "bottom";
      show-recents = false;
      tilesize = 48;
    };

    finder = {
      AppleShowAllExtensions = true;
      FXEnableExtensionChangeWarning = false;
      _FXShowPosixPathInTitle = true;
    };

    NSGlobalDomain = {
      AppleKeyboardUIMode = 3;
      ApplePressAndHoldEnabled = false;
      InitialKeyRepeat = 15;
      KeyRepeat = 2;
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
      NSNavPanelExpandedStateForSaveMode = true;
      NSNavPanelExpandedStateForSaveMode2 = true;
    };

    screencapture.location = "~/Pictures/Screenshots";
    screensaver.askForPasswordDelay = 10;
  };

  # Keyboard and input settings
  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToControl = true;
  };
}

{ config, pkgs, ... }: {
  # macOS machine configuration
  # This is a generic macOS configuration that can be used for any Mac

  # Enable Touch ID for sudo (new syntax for nix-darwin 25.11+)
  security.pam.services.sudo_local.touchIdAuth = true;

  # System-wide packages specific to this machine
  environment.systemPackages = with pkgs; [
    # Add machine-specific packages here if needed
  ];

  # Networking
  networking.hostName = "teien-mac";
  networking.computerName = "teien";

  # Time zone
  time.timeZone = "Asia/Tokyo";
}

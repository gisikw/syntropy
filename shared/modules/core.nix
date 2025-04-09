{ config, lib, pkgs, ... }: {
  nixpkgs.config.allowUnfree = true;
  networking.usePredictableInterfaceNames = false;
  users.mutableUsers = false;

  users.users.syntropy = {
    isNormalUser = true;
    home = "/home/syntropy";
    description = "Syntropy";
    extraGroups = [ "wheel" ];
    hashedPassword = "!";
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDzPrPPEas38nmBflAEHKwJ5COtZwGBOjQ/wAcM4Hit1 syntropy deploy key" ];
  };

  security.sudo.extraConfig = ''
    syntropy ALL=(ALL) NOPASSWD: ALL
  '';

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.PermitRootLogin = "no";
  };

  environment.systemPackages = with pkgs; [
    inetutils
    mtr
    sysstat
    neovim
  ];
}

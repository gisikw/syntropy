{ modulesPath, config, lib, pkgs, ... }: {
  imports = [ "${modulesPath}/profiles/qemu-guest.nix" ];

  hardware.enableAllFirmware = true;

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.enable = true;

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "uas" "usbhid" "sd_mod" ];
  boot.kernelModules = [ "kvm-intel" ];

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/BOOT";
    fsType = "vfat";
  };

  networking.networkmanager.enable = false;
  networking.wireless.enable = true;

  age.identityPaths = [ "/etc/agenix/identity" ];

  age.secrets.wifi = {
    file = ../../../secrets/wifi.age;
    mode = "0400";
    owner = "root";
  };

  systemd.services.setup-wifi = {
    description = "Install WPA supplicant config from agenix secret";
    wantedBy = [ "multi-user.target" ];
    after = [ "network-pre.target" ];
    before = [ "network.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.coreutils}/bin/cp ${config.age.secrets.wifi.path} /etc/wpa_supplicant.conf";
    };
  };
}

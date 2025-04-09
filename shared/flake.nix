{
  description = "Shared modules for syntropy hosts";

  outputs = { self }: {
    modules = {
      core = import ./modules/core.nix;
      hardware.linode = import ./modules/hardware/linode.nix;
      hardware.beelink = import ./modules/hardware/beelink.nix;
    };
  };
}

# 💥 Syntropy

An exploratory repository for leveraging NixOS to manage hobbyist infrastructure.

* Assumes you have a NixOS install already running on the host machine
* Assumes you have a `syntropy` user with passwordless sudo
* Depends on a gitignored `inventory.ini` file in the root directory with IPs/hostnames

```ini
[hosts]
myHost = 192.168.1.1
```

### Beelink Setup

After installing from the NixOS LiveCD, be sure to run
* Enabling SSH in /etc/nixos/configuration.nix

Then, remotely, prior to deploying, be sure to
* Visudo and grant syntropy ALL=(ALL) NOPASSWD: ALL
* fatlabel /dev/sda1 BOOT
* e2label /dev/sda2 nixos
* Place the host agenix key at /etc/agenix/identity
* Copy the publickey to ~/.ssh/authorized_keys

## 🖥️ Usage

```
just deploy <host>
```

## 🎯 Goals

* Specify as much as possible deterministically across multiple machines
* Stop returning to hobby projects 6 months later and wondering where the Docker compose file is
* Stress-test Nix and evaluate the utility vs annoyance balance

## 📜 License

Apache 2.0 © Kevin Gisi

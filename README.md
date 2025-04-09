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

There's an assumption of a boot partition labeled `BOOT`, and a root partition
labeled `nixos` in /dev/sda. They also need keys at /etc/agenix/identity that are
permitted to decrypt the agenix secrets.

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

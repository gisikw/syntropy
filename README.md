# 💥 Syntropy

An exploratory repository for leveraging NixOS to manage hobbyist infrastructure.

* Assumes you have a NixOS install already running on the host machine
* Assumes you have a `syntropy` user with passwordless sudo
* Depends on a gitignored `inventory.ini` file in the root directory with IPs/hostnames

```ini
[hosts]
myHost = 192.168.1.1
```

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

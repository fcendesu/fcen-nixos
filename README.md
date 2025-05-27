# NixOS Configuration

A personal NixOS configuration for system setup and management.

## Overview

This repository contains the NixOS configuration files for a desktop system with GNOME desktop environment.

## Features

- **Desktop Environment**: GNOME with GDM display manager
- **Shell**: Zsh with Oh My Zsh and Powerlevel10k theme
- **Applications**: VS Code, Brave browser, Kitty terminal
- **Localization**: Turkish keyboard layout with English GB locale
- **Audio**: PipeWire audio system
- **Package Management**: Flatpak support enabled

## Installation

1. Clone this repository
2. Copy `configuration.nix` to `/etc/nixos/`
3. Run `sudo nixos-rebuild switch`

## System Details

- Hostname: nixos
- Timezone: Europe/Istanbul
- Kernel: Latest Linux kernel
- Bootloader: systemd-boot with EFI support

## User Configuration

Default user `fcen` with:

- NetworkManager access
- Wheel group membership
- Zsh as default shell

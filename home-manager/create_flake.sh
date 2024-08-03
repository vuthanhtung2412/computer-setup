#!/bin/bash

# Detect system architecture
ARCH=$(uname -m)
case $ARCH in
    x86_64)
        ARCH="x86_64"
        ;;
    aarch64)
        ARCH="aarch64"
        ;;
    *)
        echo "Unsupported architecture: $ARCH"
        exit 1
        ;;
esac

# Detect operating system
OS=$(uname)
case $OS in
    Linux)
        SYSTEM="${ARCH}-linux"
        ;;
    Darwin)
        SYSTEM="${ARCH}-darwin"
        ;;
    *)
        echo "Unsupported operating system: $OS"
        exit 1
        ;;
esac

echo $SYSTEM

sed -e "s|<system>|$SYSTEM|g" -e "s|<user>|$USER|g" "flake-template.nix" > flake.nix
sed -e "s|<home>|$HOME|g" -e "s|<user>|$USER|g" "home-template.nix" > home.nix
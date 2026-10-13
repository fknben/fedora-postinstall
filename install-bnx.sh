#!/bin/bash
set -e

echo "=== 1. Configuration Anti-Bloat ==="
echo "install_weak_deps=False" | sudo tee -a /etc/dnf/dnf.conf

echo "=== 2. Ajout des dépôts externes ==="
sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
                    https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# Dépôts pour KineticWE et Zen Browser
sudo dnf copr enable -y linuxgamerlife/lgl-experimental
sudo dnf copr enable -y tofik/nwg-shell
sudo dnf copr enable -y sneexy/zen-browser

echo "=== 3. Mise à jour initiale ==="
sudo dnf upgrade -y

echo "=== 4. Installation des fondations du système ==="
sudo dnf install -y \
  sddm \
  polkit \
  pipewire-pulseaudio wireplumber \
  xorg-x11-server-Xwayland \
  google-noto-fonts-common \
  NetworkManager-wifi

echo "=== 5. Installation de l'environnement, utilitaires et jeux ==="
# DNF gérera automatiquement les conflits libcurl/ffmpeg grâce à --allowerasing
sudo dnf install -y --allowerasing \
  ffmpeg \
  mesa-va-drivers-freeworld \
  gstreamer1-plugins-bad-free-extras gstreamer1-plugins-bad-freeworld gstreamer1-plugins-ugly \
  zen-browser \
  kineticwe kitty fish neovim stow git \
  podman podman-compose podman-docker \
  nwg-look adw-gtk3-theme qt5ct qt6ct \
  steam gamemode mangohud steam-devices

echo "=== 6. Configuration des services et de l'utilisateur ==="
sudo systemctl enable sddm.service
sudo chsh -s /usr/bin/fish $USER

echo "=== Installation terminée ! ==="

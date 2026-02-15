#!/bin/bash

set -e

version=$1
package_name="Rouletinium"
maintainer="Łukasz Plich <l.plich@skeletonek.com>"
url="https://www.skeletonek.com/apps/rouletinium"

run_fpm() {
  file_ext=$1
  if [[ $1 == "pacman" ]]; then
    file_ext="tar.zst"
  fi

  fpm \
    -s dir \
    -t "$1" \
    -p "build/${package_name}-${version}-Linux_x64.${file_ext}" \
    --force \
    --name ${package_name} \
    --version "${version}" \
    --architecture amd64 \
    --license "GPL-3.0" \
    --maintainer "${maintainer}" \
    --url "${url}" \
    build/linux/x64/release/bundle/=/usr/share/rouletinium \
    linux/rouletinium=/usr/bin/rouletinium \
    media/logo/RouletiniumLogo.png=/usr/share/pixmaps/rouletinium.png \
    linux/rouletinium.desktop=/usr/share/applications/rouletinium.desktop
}

if [[ -z "$1" ]]; then
  echo "Missing argument: version"
  exit 1
fi

run_fpm deb
run_fpm rpm
run_fpm pacman

flatpak-builder --repo build/flatpak-repo --force-clean build/flatpak-build linux/rouletinium-flatpak.yaml
flatpak build-bundle build/flatpak-repo "build/Rouletinium-${version}-Linux_x64.flatpak" com.skeletonek.rouletinium

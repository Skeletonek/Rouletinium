# Rouletinium

![RouletiniumBannerAnim](media/anim/RouletiniumBannerAnim.gif)

A simple roulette / wheel-of-names application built with [Flutter](https://flutter.dev/) using the [roulette](https://pub.dev/packages/roulette) package.

It runs on **Android, Linux, Windows, and Web**.

![Rouletinium](media/screenshots/Rouletinium.webp)

## Installation

Pre-built binaries for Windows, Linux, and Android are available on the [Releases](https://gitlab.com/Skeletonek/Rouletinium/-/releases) page.

The **web** version is published at [rouletinium.skeletonek.com](https://rouletinium.skeletonek.com/).

> [!NOTE]
> Web build tracks the latest `main` branch, so it may behave differently from the released binaries.

## Building from source

1. Install [FVM](https://fvm.app/) for easy Flutter SDK management. Use below command to configure Flutter using FVM 
   ```bash
   fvm install
   fvm flutter pub get
   ```
2. The `roulette` UI package is a git **submodule** — initialize it:
   ```bash
   git submodule update --init
   ```

### Per-platform build

- **Web**
  ```bash
  fvm flutter build web
  ```
- **Android** (APK)
  ```bash
  fvm flutter build apk --release
  ```
- **Linux** (deb / rpm / pacman + Flatpak)
  ```bash
  fvm flutter build linux --release
  ./linux_package.sh            # packages into build/ and copies build/rouletinium.deb for the Flatpak step
  ```
- **Windows** (Inno Setup installer)
  ```powershell
  fvm flutter build windows --release
  powershell -File windows\windows_package.ps1
  ```
  Requires [Inno Setup](https://jrsoftware.org/isinfo.php) (`iscc` on PATH, or set `$env:ISCC`).

## License

Rouletinium is distributed under the [GNU GPL v3.0](LICENSE).

## LLM Usage 
AI assists with code generation and feature planning, but final review, testing, and quality control remains entirely human-driven.

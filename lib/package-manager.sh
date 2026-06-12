#!/usr/bin/env bash
# Cross-distro package installation helper.
# Source this file, then call: pkg_install <debian-package-name>...
# Package names are given in Debian/Ubuntu form and translated per distro.

detect_package_manager() {
    local pm
    for pm in apt-get dnf yum pacman zypper apk brew; do
        if command -v "$pm" >/dev/null 2>&1; then
            echo "$pm"
            return 0
        fi
    done
    return 1
}

# map_package <pm> <debian-name>
# Echoes the package name(s) for the given package manager.
map_package() {
    local pm=$1 pkg=$2
    case "$pkg" in
        build-essential)
            case "$pm" in
                dnf|yum|zypper) echo "gcc gcc-c++ make" ;;
                pacman)         echo "base-devel" ;;
                apk)            echo "build-base" ;;
                brew)           echo "" ;; # Xcode CLT provides toolchain
                *)              echo "$pkg" ;;
            esac ;;
        libreadline-dev)
            case "$pm" in
                dnf|yum|zypper) echo "readline-devel" ;;
                pacman)         echo "readline" ;;
                apk)            echo "readline-dev" ;;
                brew)           echo "readline" ;;
                *)              echo "$pkg" ;;
            esac ;;
        *) echo "$pkg" ;; # most names (tmux, zsh, ripgrep, curl, unzip, stow) are universal
    esac
}

pkg_install() {
    local pm
    pm=$(detect_package_manager) || {
        echo "ERROR: no supported package manager found (apt-get/dnf/yum/pacman/zypper/apk/brew)." >&2
        echo "Please install manually: $*" >&2
        return 1
    }

    local pkgs=() p mapped m
    for p in "$@"; do
        mapped=$(map_package "$pm" "$p")
        # word-split intentionally: one debian name can map to several packages
        for m in $mapped; do pkgs+=("$m"); done
    done

    if [[ ${#pkgs[@]} -eq 0 ]]; then
        echo "Nothing to install for $pm."
        return 0
    fi

    echo "Installing with $pm: ${pkgs[*]}"
    case "$pm" in
        apt-get) sudo apt-get update && sudo apt-get install -y "${pkgs[@]}" ;;
        dnf)     sudo dnf install -y "${pkgs[@]}" ;;
        yum)     sudo yum install -y "${pkgs[@]}" ;;
        pacman)  sudo pacman -S --needed --noconfirm "${pkgs[@]}" ;; # no -Sy: avoid partial upgrade
        zypper)  sudo zypper --non-interactive install "${pkgs[@]}" ;;
        apk)     sudo apk add "${pkgs[@]}" ;;
        brew)    brew install "${pkgs[@]}" ;;
    esac
}

#!/usr/bin/env bash
# ==============================================================================
# Bootstrap script for Mac setup using Ansible
#
# This script prepares a fresh macOS system by:
# 1. Installing Apple Command Line Tools (if not present)
# 2. Installing Homebrew (if not present)
# 3. Installing Ansible via Homebrew
# 4. Installing required Ansible Galaxy collections
# 5. Executing the Ansible playbook
# ==============================================================================

set -euo pipefail

# ANSI color codes
BOLD="\033[1m"
GREEN="\033[0;32m"
BLUE="\033[0;34m"
YELLOW="\033[0;33m"
RESET="\033[0m"

log_info() {
    printf "${BLUE}${BOLD}[INFO]${RESET} %s\n" "$1"
}

log_success() {
    printf "${GREEN}${BOLD}[OK]${RESET} %s\n" "$1"
}

log_warn() {
    printf "${YELLOW}${BOLD}[WARN]${RESET} %s\n" "$1"
}

# 1. Check & Install Xcode Command Line Tools
install_xcode_tools() {
    log_info "Checking Xcode Command Line Tools..."
    if ! xcode-select -p &>/dev/null; then
        log_info "Installing Xcode Command Line Tools..."
        xcode-select --install || true
        log_warn "Please complete the Xcode Command Line Tools installation prompt if visible."
        log_warn "Press Return once installation is complete to continue..."
        read -r
    else
        log_success "Xcode Command Line Tools already installed."
    fi
}

# 2. Check & Install Homebrew
install_homebrew() {
    log_info "Checking Homebrew..."
    if ! command -v brew &>/dev/null; then
        # Check standard Homebrew locations for Apple Silicon vs Intel
        if [[ -f "/opt/homebrew/bin/brew" ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        elif [[ -f "/usr/local/bin/brew" ]]; then
            eval "$(/usr/local/bin/brew shellenv)"
        else
            log_info "Homebrew not found. Installing Homebrew..."
            NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            
            # Configure shellenv for current execution
            if [[ -f "/opt/homebrew/bin/brew" ]]; then
                eval "$(/opt/homebrew/bin/brew shellenv)"
            elif [[ -f "/usr/local/bin/brew" ]]; then
                eval "$(/usr/local/bin/brew shellenv)"
            fi
        fi
    fi

    if command -v brew &>/dev/null; then
        log_success "Homebrew is available at $(which brew)"
    else
        echo "Error: Homebrew installation failed or not found in PATH." >&2
        exit 1
    fi
}

# 3. Check & Install Ansible
install_ansible() {
    log_info "Checking Ansible..."
    if ! command -v ansible &>/dev/null; then
        log_info "Installing Ansible via Homebrew..."
        brew install ansible
    fi
    log_success "Ansible is available ($(ansible --version | head -n 1))"
}

# 4. Install Ansible Galaxy Requirements
install_galaxy_requirements() {
    if [[ -f "requirements.yml" ]]; then
        log_info "Installing Ansible Galaxy collections from requirements.yml..."
        ansible-galaxy collection install -r requirements.yml --upgrade
        log_success "Ansible Galaxy requirements installed."
    fi
}

# 5. Run Ansible Playbook
run_playbook() {
    log_info "Running Ansible Playbook..."
    ansible-playbook playbook.yml "$@"
}

main() {
    echo "=================================================="
    echo "         macOS Ansible Setup Bootstrapper         "
    echo "=================================================="

    install_xcode_tools
    install_homebrew
    install_ansible
    install_galaxy_requirements

    log_info "Starting playbook execution..."
    run_playbook "$@"

    log_success "Mac setup automation completed successfully!"
}

main "$@"

# macOS Setup Automation with Ansible

Automated setup and configuration for a fresh macOS installation using Ansible and Homebrew. Designed to get a new Mac provisioned with CLI utilities, GUI applications, Mac App Store apps, development extensions, and system configurations with minimal manual intervention.

---

## Features

- **Automated Bootstrapping**: One-step script (`bootstrap.sh`) handles Xcode Command Line Tools, Homebrew, Python/Ansible, and Ansible Galaxy collections.
- **Package & App Management**:
  - **Homebrew CLI Packages**: Shell tools, developer runtimes, utilities (`bat`, `ripgrep`, `git`, `node`, `python`, etc.).  - **Homebrew Casks (GUI Apps)**: Browsers, terminals, IDEs, productivity tools (`Visual Studio Code`, `Ghostty`, `OrbStack`, `Obsidian`, `Bruno`, etc.).
  - **Mac App Store (MAS)**: Automated installation of App Store applications.
  - **Dotfiles Integration (chezmoi)**: Automatically installs chezmoi, initializes and applies your dotfiles repo.
  - **VS Code Extensions**: Automated extension installation.
- **Modular & Tagged**: Execute all tasks or selectively run components using Ansible tags (e.g. `--tags packages`, `--tags apps`, `--tags dotfiles`, `--tags vscode`).
- **macOS System Tweaks (Optional)**: Sensible UI defaults for Finder, Dock, and keyboard repeat rates.

---

## Project Structure

```text
.
├── bootstrap.sh            # Fresh install bootstrapper (installs brew & ansible, runs playbook)
├── ansible.cfg             # Local Ansible configuration
├── inventory.ini           # Localhost inventory definition
├── requirements.yml        # Ansible Galaxy collections (community.general)
├── playbook.yml            # Main playbook orchestrating setup
├── vars/
│   └── packages.yml        # List of formulas, casks, MAS apps, and extensions
└── tasks/
    ├── homebrew.yml        # Homebrew taps, CLI packages, and casks
    ├── mas.yml             # Mac App Store apps
    ├── dotfiles.yml        # chezmoi dotfile initialization & updates
    ├── ssh.yml             # Configures ~/.ssh/config and 1Password SSH Agent
    ├── vscode.yml          # Visual Studio Code extensions
    └── macos_settings.yml  # macOS system and UI preferences
```

---

## Quickstart on a Fresh Mac

### 1. Clone the repository

Open Terminal and clone this repository:

```bash
git clone <your-repo-url> ~/setup-mac
cd ~/setup-mac
```

### 2. Customize your packages

Edit [`vars/packages.yml`](vars/packages.yml) to select the programs you want installed:

```yaml
homebrew_packages:
  - git
  - ripgrep
  - node

homebrew_cask_packages:
  - visual-studio-code
  - google-chrome
  - docker
```

### 3. Run the bootstrap script

Run the automated bootstrapper:

```bash
./bootstrap.sh
```

The script will:
1. Install Apple Command Line Tools (if not already present).
2. Install Homebrew and configure environment paths for Apple Silicon / Intel.
3. Install Ansible via Homebrew.
4. Install required Ansible collections from [`requirements.yml`](requirements.yml).
5. Run [`playbook.yml`](playbook.yml) against `localhost`.

---

## Selective Execution with Tags

You can pass Ansible tags directly to `./bootstrap.sh` or run `ansible-playbook` manually:

### Run only CLI packages
```bash
./bootstrap.sh --tags packages
```

### Run only GUI applications (Casks)
```bash
./bootstrap.sh --tags casks
```

### Run only dotfiles synchronization
```bash
./bootstrap.sh --tags dotfiles
```

### Run only SSH / 1Password configuration
```bash
./bootstrap.sh --tags ssh
```

### Run only VS Code extensions
```bash
./bootstrap.sh --tags vscode
```

### Run only macOS system settings
```bash
./bootstrap.sh --tags macos-settings
```

### Dry-run (Check mode)
```bash
ansible-playbook playbook.yml --check
```

---

## Finding Program Names & App IDs

### Homebrew Formulas & Casks
Search for software available on Homebrew:
```bash
brew search <app_name>
```

### Mac App Store Apps
Search for App Store IDs using the `mas` CLI tool:
```bash
mas search "<app_name>"
```
*Note: You must be logged into the Mac App Store with your Apple ID for `mas` to install applications.*

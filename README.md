# macOS Setup Automation with Ansible

Automated setup and configuration for a fresh macOS installation using Ansible and Homebrew. Designed to get a new Mac provisioned with CLI utilities, GUI applications, development extensions, and system configurations with minimal manual intervention.

---

## Features

- **Automated Bootstrapping**: One-step script (`bootstrap.sh`) handles Xcode Command Line Tools, Homebrew, Python/Ansible, and Ansible Galaxy collections.
- **Package & App Management**:
  - **Homebrew CLI Packages**: Shell tools, developer runtimes, utilities (`bat`, `ripgrep`, `git`, `node`, `python`, etc.).  - **Homebrew Casks (GUI Apps)**: Browsers, terminals, IDEs, productivity tools (`Visual Studio Code`, `Ghostty`, `OrbStack`, `Obsidian`, `Bruno`, etc.).
  - **Dotfiles Integration**: Clones your dotfiles repo and runs the install script to symlink files into `$HOME`.
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
│   └── packages.yml        # List of formulas, casks, and extensions
└── tasks/
    ├── homebrew.yml        # Homebrew taps, CLI packages, and casks
    ├── dotfiles.yml        # Dotfile repo clone & install script execution
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

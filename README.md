# dotfiles

Personal dotfiles managed with [chezmoi](https://chezmoi.io) and encrypted with [age](https://github.com/Filippo.io/age).

## Quick start (new machine)

```bash
# macOS
brew install chezmoi age
chezmoi init --apply https://github.com/void-restack/dotfiles.git

# Linux
curl -fsLS https://get.chezmoi.io | sh -s -- init --apply https://github.com/void-restack/dotfiles.git
```

You'll be prompted for:
1. **age passphrase** — decrypts SSH keys and other secrets
2. **Email address** — used in `.gitconfig`
3. **Full name** — used in `.gitconfig`

## What's managed

| Tool | Config | Encrypted |
|------|--------|-----------|
| zsh | `.zshrc`, `.zshenv`, `.zprofile` | No |
| git | `.gitconfig` | No (templated) |
| tmux | `.tmux.conf` | No |
| kitty | `kitty.conf`, `current-theme.conf` | No |
| nvim | full config (NvChad + plugins) | No |
| atuin | `config.toml` | No |
| btop | `btop.conf` + themes | No |
| bat | tokyonight theme | No |
| SSH | 9 private keys, config, known_hosts | Yes (age) |
| nvim db_ui | `connections.json` | Yes (age) |

## Secrets

Sensitive files are encrypted with `age` and stored as `encrypted_` prefixed files in the repo.

The age private key (`key.txt.age`) is also in the repo, encrypted with a passphrase.

**If you lose the passphrase, all encrypted files are unrecoverable.** Store it in a password manager.

## Structure

```
dotfiles/
├── .chezmoi.toml.tmpl          # chezmoi config (prompts for email, name)
├── .chezmoiscripts/             # install scripts (brew, oh-my-zsh plugins)
├── dot_zshrc.tmpl               # zsh config (templated for macOS/Linux)
├── dot_gitconfig.tmpl           # git config (templated email/name)
├── dot_zprofile.tmpl            # zprofile (OrbStack on macOS only)
├── dot_zshenv                   # zshenv
├── dot_tmux.conf                # tmux config
├── dot_ripgreprc                # ripgrep config
├── private_dot_ssh/             # SSH keys + config
│   ├── encrypted_*              # age-encrypted private keys
│   ├── *.pub                    # public keys (plaintext)
│   └── encrypted_config         # age-encrypted SSH config
├── private_dot_config/          # XDG config files
│   ├── nvim/                    # Neovim config
│   ├── kitty/                   # Kitty terminal
│   ├── atuin/                   # shell history
│   ├── btop/                    # system monitor
│   ├── bat/                     # syntax-highlighted cat
│   ├── zsh/                     # sourced zsh helpers
│   └── git/ignore               # global gitignore
├── encrypted_private_dot_config/# encrypted XDG configs
│   └── nvim/db_ui/              # DB connections (has password)
├── ansible/                     # server provisioning playbooks
└── key.txt.age                  # age private key (passphrase-encrypted)
```

## Ansible server provisioning

```bash
# Provision a new Debian server
ansible-playbook ansible/playbooks/provision-server.yml \
  -e "target=<ip>" -e "ansible_user=<default_user>"

# Update all servers
ansible-playbook ansible/playbooks/update-all.yml
```

See `ansible/` for details.

## Daily operations

```bash
chezmoi edit --apply ~/.zshrc    # edit a file and apply changes
chezmoi update                   # pull latest from git and apply
chezmoi diff                     # see what would change
chezmoi cd                       # shell into source dir
```

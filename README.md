# dotfiles

My personal dotfiles, tracked with a bare Git repo whose work-tree is `$HOME`.
The pattern (sometimes called the "Atlassian method") keeps `$HOME` from being
a git repo itself, so IDEs and shell prompts don't mistake every directory
under `~` for part of this repo. See Nicola Paolucci's writeup:
<https://www.atlassian.com/git/tutorials/dotfiles>.

## What's tracked

- `.alias` — defines the `config` alias used to manage these dotfiles, and `vim → nvim`. Shell-agnostic.
- `.zshrc` — interactive shell setup (Starship, Mise, completions, PATH).
- `.gitconfig` — global Git config: SSH commit signing, sane pull/push/rebase defaults, aliases.
- `.git-hooks/pre-push` — blocks pushes that contain unsigned commits.
- `.config/nvim/` — LazyVim starter with a few extras (Elixir, Erlang, JSON, Markdown, yanky, claudecode).

## Prerequisites

Install these before checking out the repo.

| Tool | Why |
|---|---|
| `git` (≥ 2.34) | needs SSH commit signing support |
| `zsh` (≥ 5.8) | the shell the config targets — default on macOS Catalina+ |
| `starship` | prompt |
| `mise` | language runtime manager |
| `neovim` (≥ 0.10) | `vim` alias points here, and LazyVim needs it |
| `ripgrep`, `fd`, `lazygit` | LazyVim runtime deps |
| A **Nerd Font** | required for icons in Neovim/Starship; e.g. JetBrainsMono Nerd Font |

No SSH agent is required — `~/.ssh/config` defines `IdentityFile` per host.

### macOS

Zsh is already the default shell on macOS Catalina+. Install the rest via Homebrew:

```bash
brew install git starship mise neovim ripgrep fd lazygit
brew install --cask font-jetbrains-mono-nerd-font
```

### Linux

Install `git`, `zsh`, `neovim`, `ripgrep`, `fd` (sometimes packaged as `fd-find`),
and `lazygit` via your distro's package manager (zypper / apt / dnf / pacman).

Then:

- **`mise`**: `curl https://mise.run | sh`
- **`starship`**: `curl -sS https://starship.rs/install.sh | sh`
- **Nerd Font**: download from <https://www.nerdfonts.com/font-downloads> and
  drop into `~/.local/share/fonts`, then `fc-cache -f`.

Make zsh the login shell:

```bash
chsh -s "$(command -v zsh)"
```

### WSL (Windows)

Inside WSL, follow the Linux instructions for your chosen distro.
On the **Windows** side, install the Nerd Font and select it in Windows Terminal's
profile for the WSL distro.

## Installation on a fresh machine

```bash
# 1) clone the bare repo into $HOME/.cfg
git clone --bare git@github.com:jaime-pinzon/dotfiles.git "$HOME/.cfg"

# 2) define the alias for this one-shot bootstrap shell
alias config='/usr/bin/git --git-dir=$HOME/.cfg --work-tree=$HOME'

# 3) hide untracked files from `config status`
config config --local status.showUntrackedFiles no

# 4) back up anything that would conflict, then check out
mkdir -p "$HOME/.cfg-backup"
config checkout 2>&1 | grep -E "^\s+\." | awk '{print $1}' | while read f; do
    mkdir -p "$HOME/.cfg-backup/$(dirname "$f")"
    mv "$HOME/$f" "$HOME/.cfg-backup/$f"
done
config checkout

# 5) start a new login zsh — loads .zshrc, which sources .alias
exec zsh -l
```

Verify:

```bash
config status                       # should be clean
which config                        # alias loaded from .alias
git config --get user.signingkey    # should resolve to ~/.ssh/id_ed25519_personal.pub
```

## Post-install — manual steps not in the repo

A few things are intentionally not tracked (secrets, per-machine setup):

1. **SSH keys** — generate or import:
   ```bash
   ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519_personal -C "your-email@example.com"
   # repeat with _wonderful suffix if you need the work identity
   ```
   Upload the `.pub` to GitHub (Settings → SSH and GPG keys → New SSH key,
   and again under "Signing Key" if you want signature verification on github.com).

2. **`~/.ssh/config`** — per-host identity setup. The pattern used here:
   ```
   Host *
       IdentitiesOnly yes
       PreferredAuthentications publickey
   Host github.com
       HostName github.com
       User git
       IdentityFile ~/.ssh/id_ed25519_personal
   ```
   (Copy your existing config from another machine — it's deliberately untracked.)

3. **`~/.ssh/allowed_signers`** — one line per `<email> <pubkey-line>`; required
   to verify SSH-signed commits locally. Example:
   ```
   your-email@example.com ssh-ed25519 AAAA...
   ```

4. **`~/Projects/wonderful/.gitconfig`** — work-only include referenced from
   `.gitconfig`. Harmless if absent; created on demand.

## Day-to-day usage

```bash
config status                  # what changed
config add ~/.zshrc            # track a change
config commit -S -m "..."      # commit (signed)
config push                    # push to origin/main

config add ~/.new-dotfile      # start tracking a new file
```

The `pre-push` hook will refuse any unsigned commits in the push range — fix
with `git commit -S` or `git rebase --exec 'git commit --amend --no-edit -S' <range>`
(there's also a `sign-all` alias in `.gitconfig`).

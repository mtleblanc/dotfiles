# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal dotfiles for zsh, tmux, neovim, git, and starship prompt. Managed with [GNU Stow](https://www.gnu.org/software/stow/) and targets Linux (apt) and macOS (Homebrew).

## Design Goal

`install.sh` is the single entry point that should get a fresh VM or new machine fully up and running — installing all packages, cloning plugins, stowing configs, and setting zsh as the default shell. Any new tooling or configuration added to this repo should be wired into `install.sh` so a clean install remains one command.

## Key Commands

```bash
# Full setup on a new machine (installs packages, clones plugins, stows everything)
./install.sh

# Stow a single package (must use --no-folding to symlink files, not directories)
stow -R --no-folding <package>

# Stow all packages
for pkg in zsh tmux nvim git starship mise; do stow -R --no-folding "$pkg"; done
```

## Architecture

Each top-level directory is a **stow package** — its contents mirror `$HOME` so that `stow --no-folding <pkg>` creates symlinks for individual files rather than entire directories. This is critical: `--no-folding` prevents stow from symlinking a parent directory (e.g. `~/.config/nvim`) which would mix repo-managed and runtime files.

### Stow packages

- **zsh/** — `~/.zshenv` (sets `ZDOTDIR` to `~/.config/zsh`), `.zprofile` (PATH/env), `.zshrc` (interactive config). Plugins (autosuggestions, syntax-highlighting) are cloned to `~/.zsh/` by `install.sh`, not managed by stow.
- **nvim/** — LazyVim-based config. Custom plugins go in `nvim/.config/nvim/lua/plugins/`. Options, keymaps, and autocmds are in `lua/config/`.
- **tmux/** — prefix is `C-a`, vi-style navigation, uses TPM (auto-bootstrapped).
- **git/** — config at `.config/git/config` (XDG path, no `~/.gitconfig`).
- **starship/** — prompt config at `.config/starship.toml`.
- **mise/** — global [mise](https://mise.jdx.dev/) config at `.config/mise/config.toml`. Manages python, java, cmake versions.

### Conventions

- All configs use **XDG Base Directory** paths (`$XDG_CONFIG_HOME`, `$XDG_DATA_HOME`, etc.), set in `zsh/.zshenv`.
- Ubuntu compatibility: `fdfind`/`batcat` are aliased to `fd`/`bat` in `.zshrc`.
- When adding a new tool, create a new stow package directory mirroring the home directory structure.

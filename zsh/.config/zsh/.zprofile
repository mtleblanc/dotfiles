# .zprofile — login shell setup (PATH, environment)

# Homebrew (macOS)
if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi

# User binaries
[[ -d "$HOME/.local/bin" ]] && export PATH="$HOME/.local/bin:$PATH"

# mise (version manager) — shims for non-interactive shells
[[ -f "$HOME/.local/bin/mise" ]] && eval "$("$HOME/.local/bin/mise" activate zsh --shims)"

# Default editor
export EDITOR="nvim"
export VISUAL="nvim"

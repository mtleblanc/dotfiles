# .zshrc — interactive shell config

# ── History ──────────────────────────────────────────────
HISTFILE="$XDG_STATE_HOME/zsh/history"
HISTSIZE=10000
SAVEHIST=10000
mkdir -p "${HISTFILE:h}"
setopt SHARE_HISTORY          # share across sessions
setopt HIST_IGNORE_ALL_DUPS   # no duplicates
setopt HIST_REDUCE_BLANKS     # trim whitespace
setopt HIST_IGNORE_SPACE      # skip commands starting with space

# ── Completion ───────────────────────────────────────────
autoload -Uz compinit
compinit -d "$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"
mkdir -p "$XDG_CACHE_HOME/zsh"
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'  # case-insensitive

# ── Key bindings ─────────────────────────────────────────
bindkey -e  # emacs mode
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

# ── Aliases ──────────────────────────────────────────────
if [[ "$(uname)" == "Darwin" ]]; then
    alias ls='ls -G'
else
    alias ls='ls --color=auto'
fi

alias ll='ls -lah'
alias la='ls -A'
alias l='ls -CF'
alias grep='grep --color=auto'
alias ..='cd ..'
alias ...='cd ../..'
alias v='nvim'
alias g='git'

# fd-find on Ubuntu is named fdfind
command -v fdfind &>/dev/null && alias fd='fdfind'

# bat on Ubuntu is named batcat
command -v batcat &>/dev/null && alias bat='batcat'

# ── fzf ──────────────────────────────────────────────────
if command -v fzf &>/dev/null; then
    source <(fzf --zsh)
    export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border"
    # Use fd if available
    if command -v fd &>/dev/null; then
        export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
    elif command -v fdfind &>/dev/null; then
        export FZF_DEFAULT_COMMAND='fdfind --type f --hidden --follow --exclude .git'
    fi
fi

# ── Plugins ──────────────────────────────────────────────
ZSH_PLUGINS="$HOME/.zsh"

# zsh-autosuggestions
if [[ -f "$ZSH_PLUGINS/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
    source "$ZSH_PLUGINS/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

# zsh-syntax-highlighting (must be last plugin sourced)
if [[ -f "$ZSH_PLUGINS/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
    source "$ZSH_PLUGINS/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# ── Prompt ───────────────────────────────────────────────
eval "$(starship init zsh)"

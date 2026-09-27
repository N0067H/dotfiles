# ── History ─────────────────────────────────────
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000

setopt HIST_IGNORE_DUPS
setopt SHARE_HISTORY
setopt AUTO_CD

# ── Completion ──────────────────────────────────
autoload -Uz compinit
compinit

# ── Tools ───────────────────────────────────────
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

# ── fzf ─────────────────────────────────────────
source <(fzf --zsh)

# ── Aliases ─────────────────────────────────────
alias ls='eza --icons=always --group-directories-first'
alias ll='eza -lah --icons=always --group-directories-first --git'
alias la='eza -a --icons=always --group-directories-first'
alias tree='eza --tree --icons=always'
alias cat='bat'
alias grep='rg'

alias c='clear'
alias ff='fastfetch'

# Git
alias gs='git status'
alias gd='git diff'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate'

# NixOS
alias nrs='sudo nixos-rebuild switch --flake ~/dev/dotfiles#nixos'
alias nrt='sudo nixos-rebuild test --flake ~/dev/dotfiles#nixos'

# dotfiles
alias dots='cd ~/dev/dotfiles'

# User binaries
export PATH="$HOME/.local/bin:$PATH"

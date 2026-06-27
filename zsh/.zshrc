# ── .zshrc ──────────────────────────────────────────────────────────────────
# Location: ~/.zshrc

# ── XDG Base Dirs ────────────────────────────────────────────────────────────
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

# ── Path ─────────────────────────────────────────────────────────────────────
export PATH="$HOME/.local/bin:/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"

# ── History ──────────────────────────────────────────────────────────────────
HISTFILE="$XDG_DATA_HOME/zsh/history"
HISTSIZE=100000
SAVEHIST=100000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY
setopt EXTENDED_HISTORY

# ── Vi Mode ──────────────────────────────────────────────────────────────────
bindkey -v
export KEYTIMEOUT=1

# Cursor shape: block in normal mode, beam in insert mode
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] || [[ $1 == 'block' ]]; then
    echo -ne '\e[1 q'   # block cursor
  elif [[ ${KEYMAP} == main ]] || [[ ${KEYMAP} == viins ]] || [[ $1 == 'beam' ]]; then
    echo -ne '\e[5 q'   # beam cursor
  fi
}
zle -N zle-keymap-select

function zle-line-init {
  echo -ne '\e[5 q'   # beam cursor on new line
}
zle -N zle-line-init

# Keep Ctrl-R working in vi mode (overridden later by atuin)
bindkey '^R' history-incremental-search-backward

# Edit command in $EDITOR with vv in normal mode
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd 'vv' edit-command-line

# Better vi text objects (optional but nice)
bindkey -M vicmd 'H' beginning-of-line
bindkey -M vicmd 'L' end-of-line

# ── Autosuggestions ──────────────────────────────────────────────────────────
source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#585b70"   # Catppuccin surface2 — subtle grey
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20

# ── Completion ───────────────────────────────────────────────────────────────
autoload -Uz compinit
compinit -d "$XDG_CACHE_HOME/zsh/zcompdump"

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*:descriptions' format '[%d]'

# Carapace (multi-shell completion bridge)
export CARAPACE_BRIDGES='zsh,fish,bash'
source <(carapace _carapace zsh)

# ── fzf ──────────────────────────────────────────────────────────────────────
source <(fzf --zsh)

# Catppuccin Mocha theme for fzf
export FZF_DEFAULT_OPTS=" \
  --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
  --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
  --color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
  --color=selected-bg:#45475a \
  --border rounded --padding 1 --height 40% \
  --layout reverse"

export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'

# fzf preview with bat
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers {}' --preview-window=right:50%"

# ── Zoxide ───────────────────────────────────────────────────────────────────
eval "$(zoxide init zsh --cmd cd)"

# ── Atuin ────────────────────────────────────────────────────────────────────
eval "$(atuin init zsh --disable-up-arrow)"
# Atuin bound to Ctrl-R; up-arrow stays native

# ── Starship ─────────────────────────────────────────────────────────────────
eval "$(starship init zsh)"

# ── Aliases ──────────────────────────────────────────────────────────────────
alias ls='ls --color=auto'
alias ll='ls -lah'
alias la='ls -A'
alias grep='grep --color=auto'
alias vim='nvim'
alias vi='nvim'

# tmux / sesh
alias ta='tmux attach || tmux new-session -s main'
alias tl='tmux list-sessions'
alias tk='tmux kill-session -t'

# zoxide
alias z='cd'       # zoxide already replaces cd, this is just a reminder alias
alias zi='cd -i'   # interactive zoxide picker

# ── Environment ──────────────────────────────────────────────────────────────
export EDITOR='nvim'
export VISUAL='nvim'
export PAGER='less'
export LESS='-R --use-color'
export MANPAGER='sh -c "col -bx | bat -l man -p"'  # bat for man pages

# Path to your Oh My Zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load. You can pick another from ~/.oh-my-zsh/themes/
ZSH_THEME="robbyrussell"

# Which plugins would you like to load?
plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
)

# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh

# Core environment paths
[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"
[ -f "$HOME/.local/bin/env" ] && source "$HOME/.local/bin/env"
# Ensure Go binaries are in the path execution line
[ -d "$HOME/go/bin" ] && export PATH="$PATH:$HOME/go/bin"

# History configuration (OMZ sets defaults, but keeping your explicit sizes)
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000

# Standard OMZ options (explicitly set for safety)
setopt APPEND_HISTORY
setopt SHARE_HISTORY

# Added to prevent corruption
setopt INC_APPEND_HISTORY  # Writes to history immediately, not at shell exit
setopt HIST_FCNTL_LOCK     # Uses robust OS-level file locking to stop race conditions

# Fix keyboard layout on startup
if [[ "$XDG_SESSION_TYPE" != "wayland" ]]; then
    setxkbmap se 2>/dev/null
fi

# Set up fzf shell integration
[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ] && source /usr/share/doc/fzf/examples/key-bindings.zsh
[ -f /usr/share/doc/fzf/examples/completion.zsh ] && source /usr/share/doc/fzf/examples/completion.zsh

# Useful Aliases
alias ls='eza --icons --git'
alias ll='eza -l --icons --git'
alias la='eza -la --icons --git'
alias grep='rg'

# Customize autocomplete behavior (case-insensitive, tab menu navigation)
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' menu select

# Custom Command Prompt (Uncomment the line below if you want to override the OMZ theme's prompt)
# PROMPT='%n%F{green}%#%f %F{cyan}%~%f '

# Bind Ctrl+Left and Ctrl+Right arrows to skip words
bindkey "^[[1;5D" backward-word
bindkey "^[[1;5C" forward-word

eval "$(zoxide init zsh)"

echo "Welcome to your customized Oh My Zsh environment!"

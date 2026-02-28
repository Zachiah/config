export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"
HYPHEN_INSENSITIVE="true"

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

plugins=(git macos rust vi-mode volta)

VI_MODE_RESET_PROMPT_ON_MODE_CHANGE=true
VI_MODE_SET_CURSOR=true

source $ZSH/oh-my-zsh.sh

# User configuration

if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

setopt SHARE_HISTORY
HISTFILE=$HOME/.zhistory
SAVEHIST=10000
HISTSIZE=9999
KEYTIMEOUT=1
setopt HIST_EXPIRE_DUPS_FIRST

alias config="git --git-dir=$HOME/.cfg/ --work-tree=$HOME"

export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

# opencode
export PATH=/Users/zachiahsawyer/.opencode/bin:$PATH

# Added by Antigravity
export PATH="/Users/zachiahsawyer/.antigravity/antigravity/bin:$PATH"

# OpenClaw Completion
source <(openclaw completion --shell zsh)

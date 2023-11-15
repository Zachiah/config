export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git macos)
source $ZSH/oh-my-zsh.sh
export PATH=$PATH:/Users/zaciahsawyer/.spicetify
export PATH=$PATH:/Users/zaciahsawyer/Library/Python/3.9/bin
export PATH=$PATH:~/.global_npm_packages/bin
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

eval "$(/opt/homebrew/bin/brew shellenv)"
export NVM_DIR=~/.nvm
source $(brew --prefix nvm)/nvm.sh

export PNPM_HOME="/Users/zachiahsawyer/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"

[[ ! -r /Users/zachiahsawyer/.opam/opam-init/init.zsh ]] || source /Users/zachiahsawyer/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null

export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1)"
eval "$(rbenv init -)"
[ -f "/Users/zachiahsawyer/.ghcup/env" ] && source "/Users/zachiahsawyer/.ghcup/env" # ghcup-env

export ZSH="$HOME/.oh-my-zsh"
export PATH=/opt/homebrew/bin:$PATH

export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob=!{.git,.svn,node_modules,.azure,Trash,Library,.local,Movies,Music,cache,.docker}'

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"

eval "$(pyenv virtualenv-init -)"

source_if_exists () {
    if test -r "$1"; then
        source "$1"
    fi
}
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


plugins=(git nvm python macos web-search )

source_if_exists $ZSH/oh-my-zsh.sh
source_if_exists $HOME/zsh/alias.zsh

[[ -f ~/.config/p10k/p10k.zsh ]] && source ~/.config/p10k/p10k.zsh

# User configuration
bindkey -v # vim keybindings
export EDITOR='nvim'

eval "$(zoxide init zsh)"
eval "$(fzf --zsh)"

# Paths
export SCRIPTS="$HOME/bin/"
export PATH="$PATH:$SCRIPTS"
export PATH="$PATH:$HOME/.local/bin"
export GEM_HOME="$HOME/.gem"

export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

autoload -U add-zsh-hook
autoload zmv

#edit command line in vim
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^x^e' edit-command-line

load-nvmrc() {
  local nvmrc_path
  nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version
    nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$(nvm version)" ]; then
      nvm use
    fi
  elif [ -n "$(PWD=$OLDPWD nvm_find_nvmrc)" ] && [ "$(nvm version)" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}
autols(){
    ls
}

add-zsh-hook chpwd autols
add-zsh-hook chpwd load-nvmrc
load-nvmrc
# add bin to path
for file in $HOME/bin/*; do
    export PATH=$PATH:$file
done

alias per='pipenv run'

source ~/powerlevel10k/powerlevel10k.zsh-theme
source $HOME/zsh/zsh-plugs/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $HOME/zsh/zsh-plugs/fzf-dir-navigator/fzf-dir-navigator.zsh

add_to_pythonpath_if_needed() {
  local dir="$1"
  if [ -d "$dir" ]; then
    if [ -f "$dir/Pipfile" ] || [ -n "$(find "$dir" -maxdepth 1 -name '*.py' -print -quit)" ]; then
      export PYTHONPATH="$PYTHONPATH:$dir"
    fi
  fi
}

directories_to_check=(
  "$HOME/Repos"
  "$HOME/workspace"
)
source $HOME/bin/.env

chpwd() {
    add_to_pythonpath_if_needed "$PWD"
}
clear_screen() {
  zle clear-screen
}
zle -N clear_screen
bindkey '^O' clear_screen

load_pyenv() {

    eval "$(pyenv init -)"
}
alias pyenv='unalias pyenv; load_pyenv; pyenv'

for dir in "${directories_to_check[@]}"; do
  add_to_pythonpath_if_needed "$dir"
done
export PATH="$HOME/.dotnet/tools:$PATH"
export PATH="$PATH:$(go env GOPATH)/bin"


# Added by Windsurf
export PATH="/Users/johnhill/.codeium/windsurf/bin:$PATH"
export PATH=$PATH:/usr/local/go/bin


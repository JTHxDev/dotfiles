export ZSH="$HOME/.oh-my-zsh"

# OS-specific init (must be first — sets up PATH, prompt prep, etc.)
case "$OSTYPE" in
  darwin*) [[ -r $HOME/zsh/os/macos.zsh ]] && source $HOME/zsh/os/macos.zsh ;;
  linux*)  [[ -r $HOME/zsh/os/linux.zsh ]] && source $HOME/zsh/os/linux.zsh ;;
esac

export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob=!{.git,.svn,node_modules,.azure,Trash,Library,.local,Movies,Music,cache,.docker}'

# pyenv (only if installed)
if [ -d "$HOME/.pyenv" ]; then
  export PYENV_ROOT="$HOME/.pyenv"
  command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
  command -v pyenv >/dev/null && eval "$(pyenv virtualenv-init -)"
fi

source_if_exists () {
    if test -r "$1"; then
        source "$1"
    fi
}

plugins=(git nvm python macos web-search )

source_if_exists $ZSH/oh-my-zsh.sh
source_if_exists $HOME/zsh/alias.zsh

[[ "$OSTYPE" == darwin* && -f ~/.config/p10k/p10k.zsh ]] && source ~/.config/p10k/p10k.zsh

# User configuration
bindkey -v # vim keybindings
export EDITOR='nvim'

command -v zoxide >/dev/null && eval "$(zoxide init zsh)"
command -v fzf    >/dev/null && eval "$(fzf --zsh)"

# Paths
export SCRIPTS="$HOME/bin/"
export PATH="$PATH:$SCRIPTS"
export PATH="$PATH:$HOME/.local/bin"
export GEM_HOME="$HOME/.gem"

autoload -U add-zsh-hook
autoload zmv

#edit command line in vim
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^x^e' edit-command-line

load-nvmrc() {
  command -v nvm_find_nvmrc >/dev/null || return
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

[[ "$OSTYPE" == darwin* && -r ~/powerlevel10k/powerlevel10k.zsh-theme ]] && source ~/powerlevel10k/powerlevel10k.zsh-theme
source_if_exists $HOME/zsh/zsh-plugs/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source_if_exists $HOME/zsh/zsh-plugs/fzf-dir-navigator/fzf-dir-navigator.zsh

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
source_if_exists $HOME/bin/.env

chpwd() {
    add_to_pythonpath_if_needed "$PWD"
}
clear_screen() {
  zle clear-screen
}
zle -N clear_screen
bindkey '^O' clear_screen

if command -v pyenv >/dev/null; then
  load_pyenv() { eval "$(pyenv init -)" }
  alias pyenv='unalias pyenv; load_pyenv; pyenv'
fi

for dir in "${directories_to_check[@]}"; do
  add_to_pythonpath_if_needed "$dir"
done
[ -d "$HOME/.dotnet/tools" ] && export PATH="$HOME/.dotnet/tools:$PATH"
command -v go >/dev/null && export PATH="$PATH:$(go env GOPATH)/bin"

# bun
if [ -d "$HOME/.bun" ]; then
  [ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
  export BUN_INSTALL="$HOME/.bun"
  export PATH="$BUN_INSTALL/bin:$PATH"
fi

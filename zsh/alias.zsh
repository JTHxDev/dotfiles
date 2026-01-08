#!/usr/bin/env zsh
alias reload='source ~/.zshrc'
alias pipenv-list='for venv in ~/.local/share/virtualenvs/* ; do basename $venv; cat $venv/.project | sed "s/\(.*\)/\t\1\n/" ; done'
alias f='cd $(fd --type directory | fzf)'
alias ls='eza'
alias ll='eza -alh'
alias tree='eza --tree'
alias tgig='touch .gitignore;'
alias pn='pnpm'
alias pni='pnpm install'
alias pnu='pnpm update'
alias pnlp='pnpm m ls --depth -1 --json'
if command -v bat > /dev/null; then
    alias cat='bat'
fi

alias kys="tmux kill-server"
alias tmuxa="tmux attach-session -t"
alias tmuxl="tmux list-sessions"

alias vi="nvim"
#-------Locations--------
hash -d repos=$HOME/Repos
hash -d dotf=$HOME/dotfiles
hash -d conf=$HOME/.config
hash -d bin=$HOME/bin
hash -d icloud=$HOME/Library/Mobile\ Documents/com~apple~CloudDocs
alias am="zsh $HOME/bin/scripts/am.sh"
hash -d notes=$HOME/Library/Mobile\ Documents/com~apple~CloudDocs/Notes
#-------Web dev----------
alias rmnm="rm -r node_modules"

alias gcs='gh copilot suggest'
alias gce='gh copilot explain'


# suffix
alias -s go='$EDITOR'
alias -s py='$EDITOR'
alias -s ts='$EDITOR'
alias -s js='$EDITOR'
alias -s java='$EDITOR'
alias -s rs='$EDITOR'
alias -s mov='open'
alias -s pdf='open'
alias -s png='open'
alias -s jpg='open'
alias -s jpeg='open'
alias -s gif='open'
alias -s json='jless'
alias -s yaml='bat -l yaml'
alias -s yml='bat -l yaml'


# globals
alias -g C='| pbcopy'
alias -g JQ='| jq .'

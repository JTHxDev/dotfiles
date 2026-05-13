#!/usr/bin/env zsh
# macOS-specific zsh init. Sourced from .zshrc.

# Homebrew
export PATH=/opt/homebrew/bin:$PATH

# nvm via brew
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

# Named directory shortcuts (cd ~icloud, ~obsid, ~notes)
hash -d icloud=$HOME/Library/Mobile\ Documents/com~apple~CloudDocs
hash -d obsid=$HOME/Library/Mobile\ Documents/icloud~md~obsidian/Documents
hash -d notes=$HOME/Library/Mobile\ Documents/com~apple~CloudDocs/Notes

# Open files via macOS `open`
alias -s mov='open'
alias -s pdf='open'
alias -s png='open'
alias -s jpg='open'
alias -s jpeg='open'
alias -s gif='open'

# Clipboard pipe
alias -g C='| pbcopy'

# Misc PATHs
export PATH="$HOME/.codeium/windsurf/bin:$PATH"
export PATH="$PATH:/usr/local/go/bin"

#!/usr/bin/env zsh
# Linux-specific zsh init. Sourced from .zshrc.

# Local npm prefix (avoids needing sudo for `npm install -g`)
export NPM_CONFIG_PREFIX="$HOME/.npm-global"
[ -d "$NPM_CONFIG_PREFIX/bin" ] && export PATH="$NPM_CONFIG_PREFIX/bin:$PATH"

# Ubuntu/Debian ship fd as `fdfind` and bat as `batcat`
if ! command -v fd >/dev/null && command -v fdfind >/dev/null; then
  alias fd='fdfind'
fi
if ! command -v bat >/dev/null && command -v batcat >/dev/null; then
  alias bat='batcat'
fi

# Open files via xdg-open
if command -v xdg-open >/dev/null; then
  alias -s mov='xdg-open'
  alias -s pdf='xdg-open'
  alias -s png='xdg-open'
  alias -s jpg='xdg-open'
  alias -s jpeg='xdg-open'
  alias -s gif='xdg-open'
fi

# Clipboard pipe (X11 → xclip, Wayland → wl-copy, headless → noop)
if command -v xclip >/dev/null; then
  alias -g C='| xclip -selection clipboard'
elif command -v wl-copy >/dev/null; then
  alias -g C='| wl-copy'
fi

# nvm (sourced lazily — heavy)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# bun
export BUN_INSTALL="$HOME/.bun"
[ -d "$BUN_INSTALL/bin" ] && export PATH="$BUN_INSTALL/bin:$PATH"

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
[ -d "$PYENV_ROOT/bin" ] && export PATH="$PYENV_ROOT/bin:$PATH"
command -v pyenv >/dev/null && eval "$(pyenv init -)"

# go (system install in /usr/local/go)
[ -d /usr/local/go/bin ] && export PATH="$PATH:/usr/local/go/bin"
[ -d "$HOME/go/bin" ] && export PATH="$PATH:$HOME/go/bin"

# uv / cargo / other user-local bins (.zprofile already covers ~/.local/bin)
[ -d "$HOME/.cargo/bin" ] && export PATH="$HOME/.cargo/bin:$PATH"

# Starship prompt
command -v starship >/dev/null && eval "$(starship init zsh)"

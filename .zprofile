case "$OSTYPE" in
  darwin*)
    eval "$(/opt/homebrew/bin/brew shellenv)"
    [ -d "$HOME/.pyenv" ] && command -v pyenv >/dev/null && eval "$(pyenv virtualenv-init -)"
    ;;
esac

[ -d "$HOME/.local/bin" ] && export PATH="$PATH:$HOME/.local/bin"

export PATH="/usr/local/bin:$PATH"

# Homebrew
export PATH="/opt/homebrew/bin:$PATH"

# Use make installed by Homebrew instead of the version that ships with macOS
export PATH="/opt/homebrew/opt/make/libexec/gnubin:$PATH"

# Use Node 24
export PATH="/opt/homebrew/opt/node@24/bin:$PATH"

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

plugins=(git)

source $ZSH/oh-my-zsh.sh

# thefuck (lazy loaded)
fuck() {
  unset -f fuck
  eval $(thefuck --alias)
  fuck "$@"
}

alias vi=vim


# If we're running on a macOS machine, add some homebrew-specific paths.
if [[ $(uname) == "Darwin" ]]; then
  # This is needed to pick up Node versions.
  export PATH="/opt/homebrew/opt/node@20/bin:$PATH"

  # These are needed to install pygraphviz.
  export LDFLAGS="-L/opt/homebrew/opt/graphviz/lib"
  export CPPFLAGS="-I/opt/homebrew/opt/graphviz/include"
fi
# export LDFLAGS="-L/opt/homebrew/opt/openblas/lib -L/opt/homebrew/opt/graphviz/lib"
# export CPPFLAGS="-I/opt/homebrew/opt/openblas/include -I/opt/homebrew/opt/graphviz/include"
# export PKG_CONFIG_PATH="/opt/homebrew/opt/openblas/lib/pkgconfig"
# export OPENBLAS="$(brew --prefix openblas)"

# NVM (lazy loaded for faster shell startup)
export NVM_DIR="$HOME/.nvm"
nvm() {
  unset -f nvm node npm npx
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  nvm "$@"
}
node() { unset -f node npm npx; nvm use default >/dev/null 2>&1; node "$@" }
npm() { unset -f node npm npx; nvm use default >/dev/null 2>&1; npm "$@" }
npx() { unset -f node npm npx; nvm use default >/dev/null 2>&1; npx "$@" }

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/nathan/.cache/lm-studio/bin"
# Docker CLI completions (fpath only - compinit handled by oh-my-zsh)
fpath=(/Users/nathan/.docker/completions $fpath)

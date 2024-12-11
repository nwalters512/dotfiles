export PATH="/usr/local/bin:$PATH"

# Homebrew
export PATH="/opt/homebrew/bin:$PATH"

# Use Python3.10 for now
export PATH="/opt/homebrew/opt/python@3.10/libexec/bin:$PATH"

# Use make installed by Homebrew instead of the version that ships with macOS
export PATH="/opt/homebrew/opt/make/libexec/gnubin:$PATH"

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

plugins=(git)

source $ZSH/oh-my-zsh.sh

# thefuck
eval $(thefuck --alias)

alias vi=vim

# For autocompletion.
autoload -U compinit && compinit


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

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/nathan/.cache/lm-studio/bin"

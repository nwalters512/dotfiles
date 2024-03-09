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

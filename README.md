# dotfiles
This repository exists to track my custom dotfiles. It includes a script to quickly get everything up and running on a new machine. My script does the following:

* Back up any existing dotfiles in your home directory to `~/.dotfiles_old`
* Creates symbolic links to dotfiles in `~/.dotfiles`
* Clones the [`oh-my-zsh`](https://github.com/robbyrussell/oh-my-zsh) repositofy into `~/.dotfiles
* Attempts to install `zsh` if it is not installed
* Sets `zsh` as the default shell

## Usage
This repository should be cloned to `~/.dotfiles`. Then, run the included `install.sh` script to set everything up.

A nice one-liner to get started quickly:

```
mkdir ~/.dotfiles && cd ~/.dotfiles && git clone https://github.com/nwalters512/dotfiles.git . && chmod +x install.sh && ./install.sh
```

My install script is based on [michaeljsmalley's script](https://github.com/michaeljsmalley/dotfiles/blob/master/makesymlinks.sh), with the minor additions of some code to handle running `install` on a system that's been configured before. If that's the case, the script will tell you when the correct symlinks already exist, if `zsh` is already set as the default shell, etc.

#!/bin/bash
############################
# .make.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/.dotfiles
# Based on https://github.com/michaeljsmalley/dotfiles/blob/master/makesymlinks.sh
############################

########## Variables

dir=~/.dotfiles                    # dotfiles directory
olddir=~/.dotfiles_old             # old dotfiles backup directory
files="bashrc vimrc zshrc oh-my-zsh"    # list of files/folders to symlink in homedir

##########

# create dotfiles_old in homedir
echo -n "Creating $olddir for backup of any existing dotfiles... "
mkdir -p $olddir
echo "done"

# change to the dotfiles directory
echo -n "Changing to the $dir directory... "
cd $dir
echo "done"

# move any existing dotfiles in homedir to .dotfiles_old directory, then create symlinks from the homedir to any files in the ~/.dotfiles directory specified in $files
for file in $files; do
    # only attempt to move an existing dotfile if it exists
    if [ -e ~/$.file ]; then
        echo "Moving existing dotfile .$file from ~ to $olddir"
        mv ~/.$file ~/dotfiles_old/
    fi

    # only create symbolic link if one doesn't already exist
    if [ ! -L ~/.$file ]; then
        echo "Creating symlink to .$file in home directory"
        ln -s $dir/$file ~/.$file
    elif [ $(readlink ~/.$file) = $dir/$file ]; then
        echo "Correct symlink already exists for .$file"
    else
        echo "Existing symlink for .$file points to $(readlink ~/.$file)"
        echo "Replacing with correct symlink"
        rm ~/.$file
        ln -s $dir/$file ~/.$file
    fi
done

install_zsh () {
# Test to see if zshell is installed.  If it is:
if [ -f /bin/zsh -o -f /usr/bin/zsh ]; then
    # Clone oh-my-zsh repository from GitHub only if it isn't already present
    if [[ ! -d $dir/oh-my-zsh/ ]]; then
        git clone http://github.com/robbyrussell/oh-my-zsh.git
    else
        echo "oh-my-zsh already exists at $dir/oh-my-zsh/"
    fi
    # Set the default shell to zsh if it isn't currently set to zsh
    if [[ ! $(echo $SHELL) == $(which zsh) ]]; then
        echo "Setting zshell as the default shell... "
        chsh -s $(which zsh)
        echo "done"
    else
        echo "zshell is already the default shell"
    fi
else
    # If zsh isn't installed, get the platform of the current machine
    platform=$(uname);
    # If the platform is Linux, try an apt-get to install zsh and then recurse
    if [[ $platform == 'Linux' ]]; then
        if [[ -f /etc/redhat-release ]]; then
            sudo yum install zsh
            install_zsh
        elif [[ -f /etc/debian_version ]]; then
            sudo apt-get install zsh
            install_zsh
        else
            echo "Unable to automatically install zsh"
            echo "Please install zsh, the re-run this script!"
        fi
    # If the platform is OS X, tell the user to install zsh :)
    elif [[ $platform == 'Darwin' ]]; then
        echo "Please install zsh, then re-run this script!"
        exit
    fi
fi
}

install_zsh

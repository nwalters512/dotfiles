# Get the directory in which this file is located.
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

########################
# Install dependencies #
########################

# Install Homebrew dependencies.
brew bundle install

# Install oh-my-zsh if needed.
if [ -d ~/.oh-my-zsh ]; then
  echo "oh-my-zsh already installed"
else
  echo "Installing oh-my-zsh"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

###################
# Set up dotfiles #
###################

FILES=".zshrc .vimrc"

# Create symlinks for each dotfile.
for file in $FILES; do
  # Only attempt to back up an existing dotfile it if exists.
  if [ -e ~/$file ]; then
    BACKUP_DIR=~/.dotfiles_bak
    echo "Moving existing dotfile $file from ~/ to $BACKUP_DIR"
    mkdir -p $BACKUP_DIR
    mv ~/$file $BACKUP_DIR/$file-$(date +%Y%m%d%H%M%S)
  fi

  # Only create symbolic link if one doesn't already exist.
  if [ ! -L ~/.$file ]; then
    echo "Creating symlink to $file in home directory"
    ln -s $DIR/$file ~/$file
  elif [ $(readlink ~/$file) = $DIR/$file ]; then
    echo "Correct symlink already exists for $file"
  else
    echo "Existing symlink for $file points to $(readlink ~/$file)"
    echo "Replacing with correct symlink"
    rm ~/$file
    ln -s $DIR/$file ~/$file
  fi
done


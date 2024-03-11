# Get the directory in which this file is located.
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

########################
# Install dependencies #
########################

# Install Homebrew dependencies on macOS.
if [[ $(uname) == "Darwin" ]]; then
  if [[ $(command -v brew) ]]; then
    echo "Homebrew already installed"
  else
    echo "Installing Homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  brew bundle install
fi

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
  if [ $(readlink ~/$file) = $DIR/$file ]; then
    echo "Correct symlink already exists for $file"
    continue
  fi

  if [ -L ~/$file ]; then
    echo "Existing symlink for $file points to $(readlink ~/$file)"
    echo "Replacing with correct symlink"
    rm ~/$file
    ln -s $DIR/$file ~/$file
    continue
  fi

  if [ -e ~/$file ]; then
    BACKUP_DIR=~/.dotfiles_bak
    BACKUP_FILE_NAME=$file-$(date +%Y%m%d%H%M%S)
    echo "Moving existing dotfile ~/$file to $BACKUP_DIR/$BACKUP_FILE_NAME"
    mkdir -p $BACKUP_DIR
    mv ~/$file $BACKUP_DIR/$BACKUP_FILE_NAME
  fi

  echo "Creating symlink to $file in home directory"
  ln -s $DIR/$file ~/$file
done

##########################
# Git config and alaises #
##########################

git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.st status

git config --global --add --bool push.autoSetupRemote true

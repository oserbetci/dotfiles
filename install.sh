#!/usr/bin/env bash

# Get current dir (so run this script from anywhere)
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export DOTFILES_DIR

# Package managers & packages
echo "› brew bundle"
which -s brew
if [[ $? != 0 ]] ; then
    # Install Homebrew
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    curl https://raw.githubusercontent.com/mitsuhiko/pipsi/master/get-pipsi.py | python
else
    brew update
fi

brew bundle

if [ "$(uname 2> /dev/null)" != "Linux" ]; then
  brew services start skhd
  brew services start yabai
  sh $DOTFILES_DIR/osxdefaults.sh
fi

if [ ${SHELL: -4} != "fish" ]
then
  dscl . -read /Users/$USER UserShell
  sudo sh -c "echo $(which fish) >> /etc/shells"
  chsh -s $(which fish)
  curl -Lo ~/.config/fish/functions/fisher.fish --create-dirs https://git.io/fisher
fi

# setup matplotlib
mkdir -p ~/.matplotlib
echo 'backend:TkAgg' >> ~/.matplotlib/matplotlibrc

# setup spacemacs
if test -f "~/.emacs.d/bin/doom";
then 
    echo "DOOM ALREADY INSTALLED"
else
    rm -fr ~/.emacs.d
    git clone https://github.com/hlissner/doom-emacs.git ~/.emacs.d
    (cd ~/.emacs.d; git checkout develop; git pull;./bin/doom install)
fi

# install vim plug
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
echo 'run :PlugInstall in vim'

fisher add jethrokuan/z matchai/spacefish jethrokuan/fzf fisherman/grc

echo 'setup python: https://medium.com/@henriquebastos/the-definitive-guide-to-setup-my-python-workspace-628d68552e14 and install virtual fish: pip install virtualfish'

# Bunch of symlinks
mkdir -p ~/.config
ln -svf $DOTFILES_DIR/vim ~/.config/nvim
ln -svf $DOTFILES_DIR/proselintrc ~/.proselintrc
ln -svf $DOTFILES_DIR/bin ~/.bin
ln -svf $DOTFILES_DIR/git ~/.config
ln -svf $DOTFILES_DIR/config.fish ~/.config/fish
ln -svf $DOTFILES_DIR/zshrc ~/.zshrc
ln -svf $DOTFILES_DIR/kitty ~/.config
ln -sf $DOTFILES_DIR/doom.d ~/.doom.d
git clone --depth 1 git@github.com:dexpota/kitty-themes.git ~/.config/kitty/kitty-themes
ln -s ~/.config/kitty/kitty-themes/themes/Dracula.conf ~/.config/kitty/theme.conf
ln -svf $DOTFILES_DIR/eslintrc.json ~/.eslintrc.json

ln -sf $DOTFILES_DIR/skhdrc ~/.skhdrc
ln -sf $DOTFILES_DIR/yabairc ~/.yabairc

ln -svf $DOTFILES_DIR/alias ~/.alias
ln -svf $DOTFILES_DIR/flake8 ~/.config/flake8
ln -svf $DOTFILES_DIR/functions ~/.functions
ln -sfv $DOTFILES_DIR/profile ~/.profile
mkdir $HOME/.ctags.d
ln -svf $DOTFILES_DIR/ctags $HOME/.ctags.d/default.ctags

echo 'setup org notes by syncing dropbox and running ln -svf ~/Dropbox/org ~'
ln -svf .dotfiles/pylintrc ~/.pylintrc

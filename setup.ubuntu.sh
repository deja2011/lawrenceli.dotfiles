#!/bin/sh -x

# Install packs and libs
sudo apt-get install -y git
sudo apt-get install -y python-dev
sudo apt-get install -y python3-dev
sudo apt-get install -y libffi-dev
sudo apt-get install -y libssl-dev
sudo apt-get install -y libncurses-dev
sudo apt-get install -y libxml2-dev
sudo apt-get install -y libxslt-dev
sudo apt-get install -y libmysqlclient-dev
sudo apt-get install -y libsqlite3-dev

# Install zsh
sudo apt-get install -y zsh
# Setup zsh
sudo chsh -s /usr/bin/zsh
ln -sv $HOME/Workplace/lawrenceli.dotfiles/zshrc $HOME/.zshrc.$(whoami)
echo 'user_zshconfig=$HOME/.zshrc.$(whoami)' >> $HOME/.vimrc
echo 'if [ -f $user_zshconfig ]; then' >> $HOME/.vimrc
echo '    source $user_zshconfig' >> $HOME/.vimrc
echo 'fi' >> $HOME/.vimrc

# Install tmux
sudo apt-get install -y tmux
ln -sv $HOME/Workplace/tmux.conf $HOME/.tmux.conf

# Create user local directory
sudo mkdir -p /usr/local/install
sudo mkdir -p /usr/local/bin

# Install Python-2.7.13
cd $HOME/Downloads
wget https://www.python.org/ftp/python/2.7.13/Python-2.7.13.tgz
tar -zxf Python-2.7.13.tgz
cd Python-2.7.13
./configure --prefix="/usr/local/install/Python-2.7.13" && make && sudo make install
sudo ln -sv /usr/local/install/Python-2.7.13/bin/* /usr/local/bin

# Install Python-3.6.1
cd $HOME/Downloads
wget https://www.python.org/ftp/python/3.6.1/Python-3.6.1.tgz
tar -zxf Python-3.6.1.tgz
cd Python-3.6.1
./configure --prefix="/usr/local/install/Python-3.6.1" && make && sudo make install
sudo ln -sv /usr/local/install/Python-3.6.1/bin/* /usr/local/bin

# Install Vim-8.0
cd $HOME/Downloads
git clone https://github.com/vim/vim.git
cd vim-master
./configure --with-features=huge \
    --enable-multibyte \
    --enable-rubyinterp=yes \
    --enable-pythoninterp=yes \
    --with-python-config-dir=/usr/lib/python2.7/config-x86_64-linux-gnu \
    --enable-python3interp=yes \
    --with-python3-config-dir=/usr/lib/python3.5/config-3.5m-x86_64-linux-gnu \
    --enable-perlinterp=yes \
    --enable-luainterp=yes \
    --enable-cscope \
    --prefix="/usr/local/install/Vim-8.0" && make && sudo make install
sudo ln -sv /usr/local/install/Vim-8.0/bin/* /usr/local/bin
# Setup Vim
ln -sv $HOME/Workplace/vimrc $HOME/.vimrc
mkdir -p $HOME/.vim/bundle
mkdir -p $HOME/.vim/vimswp
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim $HOME/.vim/bundle/Vundle.vim
/usr/local/bin/vim +PluginInstall +qall

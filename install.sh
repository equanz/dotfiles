#!/bin/sh

# make symbolic link
ln -s $(cd $(dirname $0) && pwd)/.zshrc $HOME/.zshrc
ln -s $(cd $(dirname $0) && pwd)/.vimrc $HOME/.vimrc
ln -s $(cd $(dirname $0) && pwd)/.emacs.d/ $HOME/.emacs.d

# message
echo "Install Completed"
echo "Hello, world!"


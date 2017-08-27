#!/bin/sh

# make symbolic link
ln -nfs $(cd $(dirname $0) && pwd)/.zshrc $HOME/.zshrc
ln -nfs $(cd $(dirname $0) && pwd)/.vimrc $HOME/.vimrc
ln -nfs $(cd $(dirname $0) && pwd)/.emacs.d/ $HOME/.emacs.d

# message
echo "Install Completed"
echo "Hello, world!"


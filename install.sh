#!/bin/sh

# make symbolic link
for f in .??*
do
  # ignores
  [[ "$f" == ".git" ]] && continue
  [[ "$f" == ".DS_Store" ]] && continue
  [[ "$f" == ".gitignore" ]] && continue

  if [ -f "$f" ]; then
    # file
    ln -nfs $(cd $(dirname $0) && pwd)/$f $HOME/$f
  else
    # directory
    ln -nfs $(cd $(dirname $0) && pwd)/$f/ $HOME/$f
  fi
done

# TODO: install brew or linuxbrew

# TODO: build and install emacs

# TODO: install some commands
# e.g. tmux, hub, zsh

# message
echo "Install Completed"
echo "Hello, world!"


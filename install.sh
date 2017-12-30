#!/bin/sh

# make symbolic link
for f_d in $(cd $(dirname $0) && pwd)/.??*
do
  f=$(basename $f_d)
  # ignores
  [[ "$f" == ".git" ]] && continue
  [[ "$f" == ".DS_Store" ]] && continue
  [[ "$f" == ".gitignore" ]] && continue

  echo $f
  if [ -d "$f" ]; then
    # directory
    ln -ns $(cd $(dirname $0) && pwd)/$f/ $HOME/$f
  else
    # file
    ln -ns $(cd $(dirname $0) && pwd)/$f $HOME/$f
  fi
done

# TODO: install brew or linuxbrew

# TODO: build and install emacs

# TODO: install some commands
# e.g. tmux, hub, zsh

# message
echo "Install Completed"
echo "Hello, world!"


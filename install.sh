#!/bin/sh

is_ignores() {
  # ignores
  for ignore in ".git" ".DS_Store" ".gitignore"; do
    [[ $1 == $ignore ]] && return 1
  done
  return 0
}

# make symbolic link
dotfiles_dir=$(cd $(dirname $0) && pwd)
for dot_path in $dotfiles_dir/.??*; do
  dot_name=$(basename $dot_path)

  # check ignores
  is_ignores $dot_name || continue

  # check already exists
  ls $HOME/$dot_name > /dev/null 2>&1 && echo "File or directory already exists: $dot_name" && continue || echo $dot_name

  if [ -d "$dot_name" ]; then
    # directory
    ln -ns $dotfiles_dir/$dot_name/ $HOME/$dot_name
  else
    # file
    ln -ns $dotfiles_dir/$dot_name $HOME/$dot_name
  fi
done

# TODO: install brew or linuxbrew

# TODO: build and install emacs

# TODO: install some commands
# e.g. tmux, hub, zsh

# message
echo "Install Completed"
echo "Hello, world!"

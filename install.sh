#!/bin/sh

is_ignores() {
  # ignores
  for ignore in '.git' '.DS_Store' '.gitignore'; do
    [[ ${1} == ${ignore} ]] && return 1
  done
  return 0
}

# make symbolic link
dotfiles_dir=$(cd $(dirname ${0}) && pwd)
for dot_path in ${dotfiles_dir}/.??*; do
  dot_name=$(basename ${dot_path})

  # check ignores
  is_ignores ${dot_name} || continue

  # check already exists
  ls ${HOME}/${dot_name} > /dev/null 2>&1 && echo "The file or directory is already existed: ${dot_name}" && continue || echo ${dot_name}

  if [ -d ${dot_name} ]; then
    # directory
    ln -ns ${dotfiles_dir}/${dot_name}/ ${HOME}/${dot_name}
  else
    # file
    ln -ns ${dotfiles_dir}/${dot_name} ${HOME}/${dot_name}
  fi
done

if [ $(uname -s) = 'Darwin' ]; then
    echo 'Darwin spcific steps'

    # install Homebrew
    if ! $(builtin command -v brew > /dev/null); then
        echo 'Install Homebrew'
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
        echo 'Homebrew is already installed'
    fi

    # install base commands
    brew install git hub tmux zsh

    # build and install GNU Emacs
    # TODO: split to another file
    if [ ! -d /Applications/Emacs.app ]; then
        echo 'Install GNU Emacs'

        DEFAULT_EMACS_VERSION=28.1
        read -p "Enter GNU Emacs version (default: ${DEFAULT_EMACS_VERSION}): " EMACS_VERSION
        EMACS_VERSION=${EMACS_VERSION:-${DEFAULT_EMACS_VERSION}}
        pushd ~/Downloads

        # install build dependencies
        brew install autoconf gnutls pkg-config texinfo

        # download sources
        curl -LO emacs-${EMACS_VERSION}.tar.gz https://ftp.gnu.org/gnu/emacs/emacs-${EMACS_VERSION}.tar.gz
        tar xzf emacs-${EMACS_VERSION}.tar.gz
        pushd emacs-${EMACS_VERSION}

        read -p "Apply patches to $(pwd) if needed..."

        # build
        ./autogen.sh
        ./configure --without-x --with-ns --with-modules --with-xwidgets CC=clang
        # use number of cores instead of 8
        make -j8
        make install -j8

        # deploy to /Applications
        cp -R nextstep/Emacs.app /Applications

        popd
        popd
        echo 'You should grant full disk access to /Applications/Emacs.app via System Preferences'
        open '/System/Applications/System Preferences.app'
    else
        echo 'GNU Emacs is already installed'
    fi
else
    echo 'non-Darwin specific steps.\nDo nothing.'
fi

# message
echo '\n\nInstallation procedures are completed\nHello, world!'

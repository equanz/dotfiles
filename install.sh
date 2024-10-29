#!/bin/sh

is_ignores() {
    # ignores
    for ignore in '.git' '.DS_Store' '.gitignore'; do
        if [ ${1} = ${ignore} ]; then return 1; fi
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

DEFAULT_EMACS_VERSION=29.1
TPM_PATH=${HOME}/.tmux/plugins/tpm
if [ $(uname -s) = 'Darwin' ]; then
    echo '\n----Darwin specific steps----\n'

    # install Homebrew
    if ! $(which brew > /dev/null); then
        echo 'Install Homebrew'
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
        echo 'Homebrew is already installed'
    fi

    # install base commands
    HOMEBREW_NO_AUTO_UPDATE=1 brew install git hub tmux zsh
    if [ ! -d ${TPM_PATH} ]; then
        git clone https://github.com/tmux-plugins/tpm.git ${TPM_PATH}
    fi

    # build and install GNU Emacs
    # TODO: split to another file
    if [ ! -d /Applications/Emacs.app ]; then
        echo 'Install GNU Emacs'

        read -p "Enter GNU Emacs version (default: ${DEFAULT_EMACS_VERSION}): " EMACS_VERSION
        EMACS_VERSION=${EMACS_VERSION:-${DEFAULT_EMACS_VERSION}}
        mkdir -p ${HOME}/src
        pushd ${HOME}/src

        # install build dependencies
        HOMEBREW_NO_AUTO_UPDATE=1 brew install autoconf gnutls pkg-config texinfo

        # download sources
        curl -L -o emacs-${EMACS_VERSION}.tar.gz https://ftp.gnu.org/gnu/emacs/emacs-${EMACS_VERSION}.tar.gz
        tar xzf emacs-${EMACS_VERSION}.tar.gz
        pushd emacs-${EMACS_VERSION}

        read -p "Apply patches to $(pwd) if needed..."

        # build
        ./autogen.sh
        ./configure --without-x --with-ns --with-native-compilation --with-modules --with-xwidgets --with-gif CC=clang
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
elif $(which apt > /dev/null); then
    echo '\n----Debian specific steps----\n'

    # install base commands
    sudo apt install git hub tmux zsh
    if [ ! -d ${TPM_PATH} ]; then
        git clone https://github.com/tmux-plugins/tpm.git ${TPM_PATH}
    fi

    # build and install GNU Emacs
    if [ ! -f ${HOME}/usr/bin/emacs ]; then
        echo 'Install GNU Emacs'

        read -p "Enter GNU Emacs version (default: ${DEFAULT_EMACS_VERSION}): " EMACS_VERSION
        EMACS_VERSION=${EMACS_VERSION:-${DEFAULT_EMACS_VERSION}}
        mkdir -p ${HOME}/src
        pushd ${HOME}/src

        # install build dependencies
        sudo apt install build-essential autoconf gnutls-bin pkg-config texinfo \
            libgtk-3-dev libwebkit2gtk-4.0-dev libgnutls28-dev libncurses-dev \
            libjpeg-dev libgif-dev libtiff-dev libgccjit-9-dev

        # download sources
        curl -L -o emacs-${EMACS_VERSION}.tar.gz https://ftp.gnu.org/gnu/emacs/emacs-${EMACS_VERSION}.tar.gz
        tar xzf emacs-${EMACS_VERSION}.tar.gz
        pushd emacs-${EMACS_VERSION}

        read -p "Apply patches to $(pwd) if needed..."

        EMACS_PREFIX=${HOME}/usr
        mkdir ${EMACS_PREFIX}

        # build
        ./autogen.sh
        ./configure --with-pgtk --with-native-compilation --with-modules --with-xwidgets --with-gif --prefix=${EMACS_PREFIX} CC=gcc
        # use number of cores instead of 8
        make -j8
        make install -j8

        popd
        popd
    else
        echo 'GNU Emacs is already installed'
    fi
else
    echo '\n----Undefined---\n'
fi

echo '\n====End of env specific steps====\n'

# message
echo '\n\nInstallation procedures are completed\nHello, world!'

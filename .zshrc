# # Path to your oh-my-zsh installation.
# zstyle ':omz:update' mode disabled
# export ZSH=${HOME}/.oh-my-zsh

# # Set name of the theme to load. Optionally, if you set this to "random"
# # it'll load a random theme each time that oh-my-zsh is loaded.
# # See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
# ZSH_THEME='blinks'

# # Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# # Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# # Example format: plugins=(rails git textmate ruby lighthouse)
# # Add wisely, as too many plugins slow down shell startup.
# plugins=''

# source ${ZSH}/oh-my-zsh.sh

# autoload add-zsh-hook
autoload -Uz add-zsh-hook

export LC_TIME=C
export PAGER=less
export LESS=-R
export LSCOLORS=Gxfxcxdxbxegedabagacad
export LS_COLORS='di=1;36:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43'
alias ls='ls -G'

# tmux
export TERM=xterm-256color

# init
if [ $(uname -s) = 'Darwin' ]; then
    # homebrew
    if [ $(uname -m) = 'arm64' ]; then
        export PACKAGE_MANAGER_PREFIX_PATH=/opt/homebrew
        export PATH=${PACKAGE_MANAGER_PREFIX_PATH}/sbin:${PACKAGE_MANAGER_PREFIX_PATH}/bin${PATH+:${PATH}}
    else
        export PACKAGE_MANAGER_PREFIX_PATH=/usr/local
        export PATH=${PACKAGE_MANAGER_PREFIX_PATH}/sbin${PATH+:${PATH}}
    fi
else
    export PACKAGE_MANAGER_PREFIX_PATH=/usr/local
fi
export CPATH=${PACKAGE_MANAGER_PREFIX_PATH}/include${CPATH+:${CPATH}}
export LIBRARY_PATH=${PACKAGE_MANAGER_PREFIX_PATH}/lib${LIBRARY_PATH+:${LIBRARY_PATH}}
export LD_LIBRARY_PATH=${PACKAGE_MANAGER_PREFIX_PATH}/lib${LD_LIBRARY_PATH+:${LD_LIBRARY_PATH}}

# custom PROMPT
if [ -f ${PACKAGE_MANAGER_PREFIX_PATH}/etc/bash_completion.d/git-prompt.sh ]; then
    source ${PACKAGE_MANAGER_PREFIX_PATH}/etc/bash_completion.d/git-prompt.sh
    export GIT_PS1_SHOWDIRTYSTATE=true
    export GIT_PS1_SHOWSTASHSTATE=true
    export GIT_PS1_SHOWCOLORHINTS=true

    function set_prompt() {
        export PROMPT="%{%f%k%b%}
%{%F{green}%}%n%{%F{blue}%}@%{%F{cyan}%}%m%{%F{green}%} %{%F{yellow}%}%~$(__git_ps1 | sed -E 's/^ \(/ %{%F{blue}%}\[%{%f%}/; s/\)$/%{%F{blue}%}\]%{%f%}/')%{%f%k%b%}%E
%#%{%f%} "
        export RPROMPT=''
    }
    set_prompt
    # fill PROMPT when zsh hook precmd
    add-zsh-hook precmd set_prompt
fi

# nodebrew
if $(builtin command -v nodebrew > /dev/null); then
    export PATH=${HOME}/.nodebrew/current/bin${PATH+:${PATH}}
fi

# n
if $(builtin command -v n > /dev/null); then
    export N_PREFIX=${HOME}/.n
    export PATH=${N_PREFIX}/bin${PATH+:${PATH}}
fi

# rbenv
if $(builtin command -v rbenv > /dev/null); then
    export PATH=${HOME}/.rbenv/bin${PATH+:${PATH}}
    eval "$(rbenv init -)"
fi

# pyenv
if $(builtin command -v pyenv > /dev/null); then
    export PYENV_ROOT=${HOME}/.pyenv
    export PATH=${PYENV_ROOT}/bin${PATH+:${PATH}}
    eval "$(pyenv init -)"
fi

# golang
if $(builtin command -v go > /dev/null); then
    export GOPATH=${HOME}/go
    export PATH=${GOPATH}/bin${PATH+:${PATH}}
fi

# history
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_verify
setopt share_history

# zsh-completions
if [ -d ${PACKAGE_MANAGER_PREFIX_PATH}/share/zsh/site-functions ]; then
    FPATH=${PACKAGE_MANAGER_PREFIX_PATH}/share/zsh/site-functions${FPATH+:${FPATH}}
fi
if [ -d ${PACKAGE_MANAGER_PREFIX_PATH}/share/zsh-completions ]; then
    FPATH=${PACKAGE_MANAGER_PREFIX_PATH}/share/zsh-completions${FPATH+:${FPATH}}
fi
autoload -U compinit
compinit -u

# with-readline alias (sftp)
if $(builtin command -v with-readline > /dev/null); then
    alias sftp='with-readline sftp'
fi

# hub
if $(builtin command -v hub > /dev/null); then
    eval "$(hub alias -s)"
fi

# zsh-autosuggestions
if [ -f ${PACKAGE_MANAGER_PREFIX_PATH}/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    source ${PACKAGE_MANAGER_PREFIX_PATH}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# direnv
if $(builtin command -v direnv > /dev/null); then
    eval "$(direnv hook zsh)"
fi

# Google Cloud SDK
if [ -d ${PACKAGE_MANAGER_PREFIX_PATH}/Caskroom/google-cloud-sdk/latest/google-cloud-sdk ]; then
    source ${PACKAGE_MANAGER_PREFIX_PATH}/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc
    source ${PACKAGE_MANAGER_PREFIX_PATH}/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc
fi

# OpenSSL
if [ -d ${PACKAGE_MANAGER_PREFIX_PATH}/opt/openssl@1.1/bin ]; then
    export PATH=${PACKAGE_MANAGER_PREFIX_PATH}/opt/openssl@1.1/bin${PATH+:${PATH}}
fi

# Java
if [ -f /usr/libexec/java_home ]; then
    alias j8="export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)"
    alias j11="export JAVA_HOME=$(/usr/libexec/java_home -v 11)"
    alias j17="export JAVA_HOME=$(/usr/libexec/java_home -v 17)"

    eval j8
fi

# Rust
if [ -f ${HOME}/.cargo/env ]; then
    source ${HOME}/.cargo/env
fi

# makeinfo
if [ -d ${PACKAGE_MANAGER_PREFIX_PATH}/opt/texinfo ]; then
    export PATH=${PACKAGE_MANAGER_PREFIX_PATH}/opt/texinfo/bin${PATH+:${PATH}}
fi

# Haskell
if [ -f ${HOME}/.ghcup/env ]; then
    source ${HOME}/.ghcup/env
fi

# Rancher Desktop
if [ -d ${HOME}/.rd/bin ]; then
    export PATH=${HOME}/.rd/bin${PATH+:${PATH}}
fi

# GNU commands
if [ -d ${PACKAGE_MANAGER_PREFIX_PATH}/opt/findutils ]; then
    export PATH=${PACKAGE_MANAGER_PREFIX_PATH}/opt/findutils/libexec/gnubin${PATH+:${PATH}}
    export MANPATH=${PACKAGE_MANAGER_PREFIX_PATH}/opt/findutils/libexec/gnuman${MANPATH+:${MANPATH}}
fi
if [ -d ${PACKAGE_MANAGER_PREFIX_PATH}/opt/gawk ]; then
    export PATH=${PACKAGE_MANAGER_PREFIX_PATH}/opt/gawk/libexec/gnubin${PATH+:${PATH}}
    export MANPATH=${PACKAGE_MANAGER_PREFIX_PATH}/opt/gawk/libexec/gnuman${MANPATH+:${MANPATH}}
fi
if [ -d ${PACKAGE_MANAGER_PREFIX_PATH}/opt/gnu-sed ]; then
    export PATH=${PACKAGE_MANAGER_PREFIX_PATH}/opt/gnu-sed/libexec/gnubin${PATH+:${PATH}}
    export MANPATH=${PACKAGE_MANAGER_PREFIX_PATH}/opt/gnu-sed/libexec/gnuman${MANPATH+:${MANPATH}}
fi
if [ -d ${PACKAGE_MANAGER_PREFIX_PATH}/opt/grep ]; then
    export PATH=${PACKAGE_MANAGER_PREFIX_PATH}/opt/grep/libexec/gnubin${PATH+:${PATH}}
    export MANPATH=${PACKAGE_MANAGER_PREFIX_PATH}/opt/grep/libexec/gnuman${MANPATH+:${MANPATH}}
fi

# local usr
# this line sould be placed at the end
export PATH=${HOME}/usr/bin${PATH+:${PATH}}

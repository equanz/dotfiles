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
export TERM=xterm-256color

# history
export HISTFILE=${HOME}/.zsh_history
export HISTSIZE=100000
export SAVEHIST=100000
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_verify
setopt share_history

# disable stty start/stop in interactive shell
[[ $- == *i* ]] && stty -ixon

# package manager
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
() {
    readonly local git_prompt_path=${PACKAGE_MANAGER_PREFIX_PATH}/etc/bash_completion.d/git-prompt.sh
    if [ -f ${git_prompt_path} ]; then
        source ${git_prompt_path}
        export GIT_PS1_SHOWDIRTYSTATE=true
        export GIT_PS1_SHOWSTASHSTATE=true
        export GIT_PS1_SHOWUNTRACKEDFILES=true
        export GIT_PS1_SHOWCOLORHINTS=true

        function set_prompt() {
            export PROMPT="%{%f%k%b%}
%{%F{green}%}%n%{%F{blue}%}@%{%F{cyan}%}%m%{%F{green}%} %{%F{yellow}%}%~$(__git_ps1 | sed -E 's/^ \(/ %{%F{blue}%}\[%{%f%}/; s/\)$/%{%F{blue}%}\]%{%f%}/')%{%f%k%b%}%E
%#%{%f%} "
        }

        # fill PROMPT when zsh hooks precmd
        add-zsh-hook precmd set_prompt
    fi
}

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

# zsh-completions
() {
    readonly local zsh_site_functions_path=${PACKAGE_MANAGER_PREFIX_PATH}/share/zsh/site-functions
    if [ -d ${zsh_site_functions_path} ]; then
        export FPATH=${zsh_site_functions_path}${FPATH+:${FPATH}}
    fi
    readonly local zsh_completions_path=${PACKAGE_MANAGER_PREFIX_PATH}/share/zsh-completions
    if [ -d ${zsh_completions_path} ]; then
        export FPATH=${zsh_completions_path}${FPATH+:${FPATH}}
    fi
}
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
() {
    readonly local zsh_autosuggestions_path=${PACKAGE_MANAGER_PREFIX_PATH}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    if [ -f ${zsh_autosuggestions_path} ]; then
        source ${zsh_autosuggestions_path}
    fi
}

# direnv
if $(builtin command -v direnv > /dev/null); then
    eval "$(direnv hook zsh)"
fi

# Google Cloud SDK
() {
    readonly local google_cloud_sdk_path=${PACKAGE_MANAGER_PREFIX_PATH}/Caskroom/google-cloud-sdk/latest/google-cloud-sdk
    if [ -d ${google_cloud_sdk_path} ]; then
        source ${google_cloud_sdk_path}/completion.zsh.inc
        source ${google_cloud_sdk_path}/path.zsh.inc
    fi
}

# OpenSSL
() {
    readonly local openssl_1_1_bin_path=${PACKAGE_MANAGER_PREFIX_PATH}/opt/openssl@1.1/bin
    if [ -d ${openssl_1_1_bin_path} ]; then
        export PATH=${openssl_1_1_bin_path}${PATH+:${PATH}}
    fi
}

# Java
if [ -f /usr/libexec/java_home ]; then
    function j() {
        readonly local libexec_java_home_path=/usr/libexec/java_home
        if [ "x${1}" != 'x' ]; then
            export JAVA_HOME=$(${libexec_java_home_path} -v ${1})
        else
            export JAVA_HOME=$(${libexec_java_home_path} -v 1.8)
        fi
    }
    eval j
fi

# Rust
() {
    readonly local cargo_env_path=${HOME}/.cargo/env
    if [ -f ${cargo_env_path} ]; then
        source ${cargo_env_path}
    fi
}

# makeinfo
() {
    readonly local texinfo_path=${PACKAGE_MANAGER_PREFIX_PATH}/opt/texinfo
    if [ -d ${texinfo_path} ]; then
        export PATH=${texinfo_path}/bin${PATH+:${PATH}}
    fi
}

# Haskell
() {
    readonly local ghcup_env_path=${HOME}/.ghcup/env
    if [ -f ${ghcup_env_path} ]; then
        source ${ghcup_env_path}
    fi
}

# Rancher Desktop
() {
    readonly local rd_bin_path=${HOME}/.rd/bin
    if [ -d ${rd_bin_path} ]; then
        export PATH=${rd_bin_path}${PATH+:${PATH}}
    fi
}

# GNU commands
() {
    readonly local findutils_path=${PACKAGE_MANAGER_PREFIX_PATH}/opt/findutils
    if [ -d ${findutils_path} ]; then
        export PATH=${findutils_path}/libexec/gnubin${PATH+:${PATH}}
        export MANPATH=${findutils_path}/libexec/gnuman${MANPATH+:${MANPATH}}
    fi
    readonly local gawk_path=${PACKAGE_MANAGER_PREFIX_PATH}/opt/gawk
    if [ -d ${gawk_path} ]; then
        export PATH=${gawk_path}/libexec/gnubin${PATH+:${PATH}}
        export MANPATH=${gawk_path}/libexec/gnuman${MANPATH+:${MANPATH}}
    fi
    readonly local gnu_sed_path=${PACKAGE_MANAGER_PREFIX_PATH}/opt/gnu-sed
    if [ -d ${gnu_sed_path} ]; then
        export PATH=${gnu_sed_path}/libexec/gnubin${PATH+:${PATH}}
        export MANPATH=${gnu_sed_path}/libexec/gnuman${MANPATH+:${MANPATH}}
    fi
    readonly grep_path=${PACKAGE_MANAGER_PREFIX_PATH}/opt/grep
    if [ -d ${grep_path} ]; then
        export PATH=${grep_path}/libexec/gnubin${PATH+:${PATH}}
        export MANPATH=${grep_path}/libexec/gnuman${MANPATH+:${MANPATH}}
    fi
}

# local usr
# this line sould be placed at the end
export PATH=${HOME}/usr/bin${PATH+:${PATH}}
export FPATH=${HOME}/usr/share${FPATH+:${FPATH}}

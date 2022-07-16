# Path to your oh-my-zsh installation.
export ZSH=${HOME}/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME='blinks'

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
if [ $(uname -s) = 'Darwin' ]; then
    plugins=(git ruby macos bundler brew emoji-clock)
else
    plugins=(git ruby bundler brew emoji-clock)
fi

source ${ZSH}/oh-my-zsh.sh

# autoload add-zsh-hook
autoload -Uz add-zsh-hook

# edit PROMPT
function set_prompt() {
    export PROMPT="%{%f%k%b%}
%{%F{green}%}%n%{%F{blue}%}@%{%F{cyan}%}%m%{%F{green}%} %{%F{yellow}%}%~%{%F{green}%}$(git_prompt_info | sed -e 's/%B//g' -e 's/%K{[^}]*}//g')%{%f%k%b%}%E
$(_prompt_char) %#%{%f%} "
    export RPROMPT=''
}
set_prompt
# fill PROMPT when zsh hook precmd
add-zsh-hook precmd set_prompt

# tmux
export TERM=xterm-256color

# homebrew
if [ $(uname -s) = 'Darwin' ]; then
    if [ $(uname -m) = 'arm64' ]; then
        BREW_PATH_PREFIX=/opt/homebrew
        export PATH=${BREW_PATH_PREFIX}/sbin:${BREW_PATH_PREFIX}/bin${PATH+:${PATH}}
    else
        BREW_PATH_PREFIX=/usr/local
        export PATH=${BREW_PATH_PREFIX}/sbin${PATH+:${PATH}}
    fi
fi
export CPATH=${BREW_PATH_PREFIX}/include${CPATH+:${CPATH}}
export LIBRARY_PATH=${BREW_PATH_PREFIX}/lib${LIBRARY_PATH+:${LIBRARY_PATH}}
export LD_LIBRARY_PATH=${BREW_PATH_PREFIX}/lib${LD_LIBRARY_PATH+:${LD_LIBRARY_PATH}}

# nodebrew
if $(builtin command -v nodebrew > /dev/null); then
    export PATH=${HOME}/.nodebrew/current/bin${PATH+:${PATH}}
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

# share history in zsh
setopt share_history

# zsh-completions
if [ -d ${BREW_PATH_PREFIX}/share/zsh/site-functions ]; then
    FPATH=${BREW_PATH_PREFIX}/share/zsh/site-functions${FPATH+:${FPATH}}
fi
if [ -d ${BREW_PATH_PREFIX}/share/zsh-completions ]; then
    FPATH=${BREW_PATH_PREFIX}/share/zsh-completions${FPATH+:${FPATH}}
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
if [ -f ${BREW_PATH_PREFIX}/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    source ${BREW_PATH_PREFIX}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# direnv
if $(builtin command -v direnv > /dev/null); then
    eval "$(direnv hook zsh)"
fi

# Google Cloud SDK
if [ -d ${BREW_PATH_PREFIX}/Caskroom/google-cloud-sdk/latest/google-cloud-sdk ]; then
    source ${BREW_PATH_PREFIX}/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc
    source ${BREW_PATH_PREFIX}/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc
fi

# OpenSSL
if [ -d ${BREW_PATH_PREFIX}/opt/openssl@1.1/bin ]; then
    export PATH=${BREW_PATH_PREFIX}/opt/openssl@1.1/bin${PATH+:${PATH}}
fi

# Java
alias j8="export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)"
alias j11="export JAVA_HOME=$(/usr/libexec/java_home -v 11)"
alias j17="export JAVA_HOME=$(/usr/libexec/java_home -v 17)"
if [ -f /usr/libexec/java_home ]; then
    j8
fi

# Rust
if [ -f ${HOME}/.cargo/env ]; then
    source ${HOME}/.cargo/env
fi

# makeinfo
if [ -d ${BREW_PATH_PREFIX}/opt/texinfo ]; then
    export PATH=${BREW_PATH_PREFIX}/opt/texinfo/bin${PATH+:${PATH}}
fi

# local usr
# this line sould be placed at the end
export PATH=${HOME}/usr/bin${PATH+:${PATH}}

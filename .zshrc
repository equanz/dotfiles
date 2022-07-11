# Path to your oh-my-zsh installation.
export ZSH=${HOME}/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="blinks"

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

# local usr
export PATH="$HOME/usr/bin:$PATH"

# tmux
export TERM=xterm-256color

# homebrew
export PATH=/usr/local/sbin:$PATH

# nodebrew
if $(builtin command -v nodebrew > /dev/null); then
    export PATH=${PATH}:${HOME}/.nodebrew/current/bin
fi

# rbenv
if $(builtin command -v rbenv > /dev/null); then
    export PATH=${HOME}/.rbenv/bin:${PATH}
    eval "$(rbenv init -)"
fi

# pyenv
if $(builtin command -v pyenv > /dev/null); then
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"
fi

# golang
if $(builtin command -v go > /dev/null); then
    export GOPATH=$HOME/go
    export PATH=$GOPATH/bin:$PATH
fi

# history
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

# share history in zsh
setopt share_history

# zsh-completions
fpath=(/usr/local/share/zsh-completions/ $fpath)

autoload -U compinit
compinit -u

# with-readline alias (sftp)
if $(builtin command -v with-readline > /dev/null); then
    alias sftp="with-readline sftp"
fi

# hub
if $(builtin command -v hub > /dev/null); then
    eval "$(hub alias -s)"
fi

# zsh-autosuggestions
if [ -f /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# direnv
if $(builtin command -v direnv > /dev/null); then
    eval "$(direnv hook zsh)"
fi

# Google Cloud SDK
if [ -d /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk ]; then
    source "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"
    source "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
fi

# OpenSSL
if [ -d /usr/local/opt/openssl/bin ]; then
    export PATH="/usr/local/opt/openssl/bin:${PATH}"
fi

# Java
alias j8="export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)"
alias j11="export JAVA_HOME=$(/usr/libexec/java_home -v 11)"
if [ -f /usr/libexec/java_home ]; then
    j8
fi

# add libxml2 to C handler
if [ -d /usr/local/opt/libxml2/include/libxml2 ]; then
    export CPATH=/usr/local/opt/libxml2/include/libxml2
fi

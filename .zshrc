# autoload add-zsh-hook
autoload -Uz add-zsh-hook

export LC_TIME=C
export PAGER=less
export LESS=-R
export LSCOLORS=Gxfxcxdxbxegedabagacad
export LS_COLORS='di=1;36:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43'
alias ls='ls -G'
export TMOUT=0

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

# custom prompt
() {
    readonly local git_prompt_path=${PACKAGE_MANAGER_PREFIX_PATH}/etc/bash_completion.d/git-prompt.sh
    if [ -f ${git_prompt_path} ]; then
        source ${git_prompt_path}
        export GIT_PS1_SHOWDIRTYSTATE=true
        export GIT_PS1_SHOWSTASHSTATE=true
        export GIT_PS1_SHOWUNTRACKEDFILES=true
        export GIT_PS1_SHOWCOLORHINTS=true
    else
        function __git_ps1() {}
    fi

    function set_prompt() {
        export PROMPT="%{%f%k%b%}
%{%F{green}%}%n%{%F{blue}%}@%{%F{cyan}%}%m%{%F{green}%} %{%F{yellow}%}%~$(__git_ps1 | perl -pe 's/^ \(/ %{%F{blue}%}\[%{%f%}/; s/\)$/%{%F{blue}%}\]%{%f%}/')%{%f%k%b%}%E ${VIRTUAL_ENV_PROMPT}
%#%{%f%} "
    }

    # fill prompt when zsh hooks precmd
    add-zsh-hook precmd set_prompt
}

# .local
export PATH=${HOME}/.local/bin${PATH+:${PATH}}

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

# Git
gwt-add() {
    local repo_path="$(git worktree list --porcelain 2>/dev/null | grep -E '^worktree' | perl -pe 's/worktree\s+//g' | grep -vF '/_wt/')"
    local repo_name="$(basename ${repo_path})"
    local branch_name="${1}"
    local worktree_name=$(echo -n "${branch_name}" | perl -pe "s/[\?\[\]\/\\\\=<>:;,'\"&\\\$#*()|~\`\!{}%+\r\n\t ]+/-/g")
    local worktree_path="${repo_path}/_wt/${worktree_name}"
    shift

    if git rev-parse --verify "${branch_name}" 2> /dev/null; then
        echo 'exists' >&2
        git worktree add "${worktree_path}" "${branch_name}" $@ && echo "${worktree_path}"
    else
        echo 'not exists' >&2
        git worktree add -b "${branch_name}" "${worktree_path}" $@ && echo "${worktree_path}"
    fi
}

gwt-remove() {
    local worktree_path="${1}"
    shift

    git worktree remove "${worktree_path}" $@
    rmdir "$(dirname ${worktree_path})" 2> /dev/null || true
}

_gwt-remove() {
    local repo_name="$(git worktree list --porcelain 2>/dev/null | grep -E '^worktree' | perl -pe 's/worktree\s+//g' | grep -vF '/_wt/')"
    local worktrees=($(git worktree list --porcelain 2>/dev/null | grep -E '^worktree' | perl -pe 's/worktree\s+//g' | grep -F '/_wt/'))
    if (( $#worktrees )); then
        _values 'subcmd' $worktrees
    fi
}
compdef _gwt-remove gwt-remove

# GitHub
export GH_TELEMETRY=false
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
        local java_version=11
        local java_arch=$(arch | perl -pe 's/^i386$/x86_64/g')

        if [ "x${1}" != 'x' ]; then
            java_version=${1}
            if [ "x${2}" != 'x' ]; then
                java_arch=${2}
            fi
        fi
        export JAVA_HOME=$(${libexec_java_home_path} -v ${java_version} -a ${java_arch})
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

# 1Password
() {
  readonly op_plugin_path=${HOME}/.config/op/plugins.sh
  if builtin command -v op > /dev/null && [ -f ${op_plugin_path} ]; then
    source ${op_plugin_path}
  fi
}

# bun
() {
    if [ -s ${HOME}/.bun/_bun ]; then
        source ${HOME}/.bun/_bun
        export BUN_INSTALL=${HOME}/.bun
        export PATH=${BUN_INSTALL}/bin${PATH+:${PATH}}
    fi
}

# Claude Code
if $(builtin command -v claude > /dev/null); then
    claude-chat() {
        readonly local tmp_for_chat=${HOME}/tmp_for_claude
        if [ ! -d ${tmp_for_chat} ]; then
            mkdir -p ${tmp_for_chat}
        fi
        pushd ${tmp_for_chat} >> /dev/null && claude $@ && popd >> /dev/null
    }
fi

# Codex
if $(builtin command -v codex > /dev/null); then
    codex-chat() {
        readonly local tmp_for_chat=${HOME}/tmp_for_codex
        if [ ! -d ${tmp_for_chat} ]; then
            mkdir -p ${tmp_for_chat}
        fi
        pushd ${tmp_for_chat} >> /dev/null && codex $@ && popd >> /dev/null
    }
fi

# fzf
if $(builtin command -v fzf > /dev/null); then
    source <(fzf --zsh)
fi

# mise
if $(builtin command -v mise > /dev/null); then
    eval "$(mise activate zsh)"
fi

# local config
() {
    readonly local local_zshrc=${HOME}/.zshrc_local
    if [ -f ${local_zshrc} ]; then
        source ${local_zshrc}
    fi
}

# local usr
# this line sould be placed at the end
export PATH=${HOME}/usr/bin${PATH+:${PATH}}
export FPATH=${HOME}/usr/share${FPATH+:${FPATH}}

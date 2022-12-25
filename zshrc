# PATH

export PATH="$HOME/.local/bin:$PATH"

alias j="jobs -l"
alias l="less"
alias duh='du -h --max-depth=1 | sort -h'
alias cpwd='cd `pwd`'
alias apwd='pwd -P'
alias vimo='vim -O'
alias vimp='vim -p'
alias mp='mkdir -p'
alias tmxa='tmux attach -t'
alias tmxl='tmux -l'
alias pyserver='python -m SimpleHTTPServer'
alias q='rlwrap -r $QHOME/l32/q'
alias vi='vim'
alias lastmod='f(){ find $1 -type f -printf "%TY-%Tm-%Td %TT %p\\n" | sort -r | head -n $2 }; f'
alias cs="cd $HOME/source"

unset noclobber

function sfind() {
    # smart finder that auto excludes subdirs of venv __pycache__ .git .idea .vscode
    find $* -not -path '*/venv*/*' -not -path '*/__pycache__/*' -not -path '*/.git/*' -not -path '*/.idea/*' -not -path '*/.vscode/*'
}

function abspath() {
    # generate absolute path from relative path
    # $1     : relative filename
    # return : absolute path
    if [ -d "$1" ]; then
        # dir
        (cd "$1"; pwd -P)
    elif [ -f "$1" ]; then
        # file
        if [[ $1 == */* ]]; then
            echo "$(cd "${1%/*}"; pwd -P)/${1##*/}"
        else
            echo "$(pwd -P)/$1"
        fi
    fi
}

function deactivate_anaconda () {

    # if Anaconda is not activated quit quietly
    if [ -z "${ANACONDA_ENV+_}" ] ; then
        return -1
    fi

    unset -f pydoc >/dev/null 2>&1

    # reset old environment variables
    # ! [ -z ${VAR+_} ] returns true if VAR is declared at all
    if ! [ -z "${_OLD_VIRTUAL_PATH+_}" ] ; then
        PATH="$_OLD_VIRTUAL_PATH"
        export PATH
        unset _OLD_VIRTUAL_PATH
    fi
    if ! [ -z "${_OLD_VIRTUAL_PYTHONHOME+_}" ] ; then
        PYTHONHOME="$_OLD_VIRTUAL_PYTHONHOME"
        export PYTHONHOME
        unset _OLD_VIRTUAL_PYTHONHOME
    fi

    # This should detect bash and zsh, which have a hash command that must
    # be called to get it to forget past commands.  Without forgetting
    # past commands the $PATH changes we made may not be respected
    if [ -n "${BASH-}" ] || [ -n "${ZSH_VERSION-}" ] ; then
        hash -r 2>/dev/null
    fi

    if ! [ -z "${_OLD_VIRTUAL_PS1+_}" ] ; then
        PS1="$_OLD_VIRTUAL_PS1"
        export PS1
        unset _OLD_VIRTUAL_PS1
    fi

    unset ANACONDA_ENV
}

function activate_anaconda () {
    deactivate_anaconda

    if [ -z "${ANACONDA_PATH+_}" -o ! -f "${ANACONDA_PATH}/bin/python" ]; then
        echo "Error: Invalid environment variable ANACONDA_PATH." >&2
        return -1
    fi

    ANACONDA_ENV="$ANACONDA_PATH"
    export ANACONDA_ENV

    _OLD_VIRTUAL_PATH="$PATH"
    PATH="$ANACONDA_PATH/bin:$PATH"
    export PATH

    # unset PYTHONHOME if set
    if ! [ -z "${PYTHONHOME+_}" ] ; then
        _OLD_VIRTUAL_PYTHONHOME="$PYTHONHOME"
        unset PYTHONHOME
    fi

    if [ -z "${VIRTUAL_ENV_DISABLE_PROMPT-}" ] ; then
        _OLD_VIRTUAL_PS1="$PS1"
        PS1="$PS1(anaconda) "
        export PS1
    fi

    # Make sure to unalias pydoc if it's already there
    alias pydoc 2>/dev/null >/dev/null && unalias pydoc

    pydoc () {
        python -m pydoc "$@"
    }

    # This should detect bash and zsh, which have a hash command that must
    # be called to get it to forget past commands.  Without forgetting
    # past commands the $PATH changes we made may not be respected
    if [ -n "${BASH-}" ] || [ -n "${ZSH_VERSION-}" ] ; then
        hash -r 2>/dev/null
    fi
}

# Fetch Windows ip address inside WSL environment
if grep -qi microsoft /proc/version 2>/dev/null; then
    export WINDOWS_IP=$(command -v pyenv >/dev/null || ip route | grep default | awk '{print $3}')
    PROXY_HTTP="http://${WINDOWS_IP}:7890"
    PROXY_SOCKS5="${WINDOWS_IP}:7890"
    function set_proxy () {
        export http_proxy="${PROXY_HTTP}"
        export https_proxy="${PROXY_HTTP}"
    }
    function unset_proxy () {
        unset http_proxy
        unset https_proxy
    }
    alias proxy=set_proxy
    alias deproxy=unset_proxy
    export DISPLAY="${WINDOWS_IP}:0.0"
fi

if [ -d "$HOME/.nvm" ]; then
    export NVM_DIR="$HOME/.nvm"
    export NVM_NODEJS_ORG_MIRROR="https://npm.taobao.org/mirrors/node/"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
fi

if [ -d "$HOME/.pyenv" ]; then
    export PYENV_ROOT="$HOME/.pyenv"
    command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"
fi

if [ -d "$HOME/go" ]; then
    export GOPATH="$HOME/go"
    export PATH="$GOPATH/bin:$PATH"
fi

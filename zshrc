alias j="jobs"
alias dud1='du -h --max-depth=1 | sort -h'
alias cpwd='cd `pwd`'
alias ppwd='pushd `pwd`'
alias apwd='pwd -P'
alias capwd='cd `apwd`'
alias papwd='pushd `apwd`'
alias lc='ls | wc -l'
alias vimo='vim -O'
alias vimp='vim -p'
alias psd='pushd'
alias ppd='popd'
alias mp='mkdir -p'

unset noclobber

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

stty erase 
stty werase ^W

snps_zshrc="$HOME/.zshrc.snps"
if [ -r $snps_zshrc ]; then
  . $snps_zshrc
fi

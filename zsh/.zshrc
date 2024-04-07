if [ "$ZSHRC_PROFILE" != "" ]; then
  zmodload zsh/zprof && zprof > /dev/null
fi

########################################
export LANG=en_US.UTF-8
export LC_TYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
# 色を使用出来るようにする
autoload -Uz colors
# colors

# ヒストリの設定
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000
# Options
# 日本語ファイル名を表示可能にする
setopt print_eight_bit

# beep を無効にする
setopt no_beep

# フローコントロールを無効にする
setopt no_flow_control

# '#' 以降をコメントとして扱う
setopt interactive_comments

# ディレクトリ名だけでcdする
setopt auto_cd
# autols
# function chpwd() { ls }

# cd したら自動的にpushdする
setopt auto_pushd
# 重複したディレクトリを追加しない
setopt pushd_ignore_dups

# 同時に起動したzshの間でヒストリを共有する
setopt share_history

# 同じコマンドをヒストリに残さない
setopt hist_ignore_all_dups

# スペースから始まるコマンド行はヒストリに残さない
setopt hist_ignore_space

# ヒストリに保存するときに余分なスペースを削除する
setopt hist_reduce_blanks

# 高機能なワイルドカード展開を使用する
setopt extended_glob

########################################
# enable path
#########################################
## OS 別の設定
case ${OSTYPE} in
    darwin*)
        # homebrew for M1
        export PATH=$PATH:/opt/homebrew/bin:/Users/k/Library/Python/3.9/bin:/opt/homebrew/opt/ruby/bin:/usr/local/opt/go/libexec/bin
        alias nvim=/Users/k/.usr/nvim-macos/bin/nvim
        ;;
    linux*)
        ;;
esac
source $HOME/.cargo/env

# Alias
alias ls='exa'
alias l='exa -hla --git'

alias lg='lazygit'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

alias mkdir='mkdir -p'

# sudo の後のコマンドでエイリアスを有効にする
alias sudo='sudo '

# global alias
alias -g L='| less'
alias -g G='| grep'
alias -g P='| peco'
alias -g W='| wc -l'

# editor
alias nv=nvim
alias vs='nvim ~/.ssh/config'
alias vz='nvim ~/.zshrc'
alias vk='nvim ~/.ssh/known_hosts'

alias gf='git fetch'
alias gsw='git switch'

# atuin
eval "$(atuin init zsh --disable-up-arrow)"

# startship prompt
eval "$(starship init zsh)"

## 補完で小文字でも大文字にマッチさせる
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

## 補完候補を一覧表示したとき、Tabや矢印で選択できるようにする
zstyle ':completion:*:default' menu select=1
bindkey '^[[Z' reverse-menu-complete

# fd を使用してディレクトリとファイルを検索し、peco でフィルタリングする関数
fd-peco-search() {
    local selected
    selected=$(fd --max-depth 5 --type file --type directory . $HOME | peco --query "$LBUFFER")

    if [ -n "$selected" ]; then
        if [ -d "$selected" ]; then
            cd "$selected"
        elif [ -f "$selected" ]; then
            # ファイルの場合、お好みのエディタで開く (ここでは vim を例とする)
            nvim "$selected"
        fi
    fi
}

# 任意のキーバインドを設定 (例: Ctrl+f)
zle -N fd-peco-search
bindkey '^f' fd-peco-search
function zsh-startuptime-slower-than-default() {
    local time_rc
    time_rc=$((TIMEFMT="%mE"; time zsh -i -c exit) &> /dev/stdout)

    local time_norc
    time_norc=$((TIMEFMT="%mE"; time zsh -df -i -c "autoload -Uz compinit && compinit -C; exit") &> /dev/stdout)
    echo "my zshrc: ${time_rc}\ndefault zsh: ${time_norc}\n"

    local result
    result=$(scale=3 echo "${time_rc%ms} / ${time_norc%ms}" | bc)
    echo "${result}x slower your zsh than the default."
}

function zsh-profiler() {
    ZSHRC_PROFILE=1 zsh -i -c zprof
}

# sheldon source
eval "$(sheldon source)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

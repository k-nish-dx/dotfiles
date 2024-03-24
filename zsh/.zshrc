if [ "$ZSHRC_PROFILE" != "" ]; then
  zmodload zsh/zprof && zprof > /dev/null
fi

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
# autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk

zinit snippet PZT::modules/helper/init.zsh

# Must Load OMZ Git library
zi snippet OMZL::git.zsh

# Load Git plugin from OMZ
zi snippet OMZP::git
zi cdclear -q

# setopt promptsubst

# completions
zinit ice wait lucid atload'_zsh_autosuggest_start'
zinit light zsh-users/zsh-autosuggestions

# syntax highlights
zinit light zdharma/fast-syntax-highlighting

########################################
export LANG=en_US.UTF-8
export LC_TYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
# 色を使用出来るようにする
autoload -Uz colors
colors

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
        export PATH=$PATH:/opt/homebrew/bin:/Users/k/Library/Python/3.9/bin
        alias nvim=/Users/k/.usr/nvim-macos/bin/nvim
        ;;
    linux*)
        alias nvim='$HOME/.nvim/squashfs-root/usr/bin/nvim'
        ;;
esac
export GOROOT=/usr/local/opt/go/libexec
export PATH=$PATH:$GOROOT/bin
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

# zoxide
eval "$(zoxide init zsh)"

# atuin
eval "$(atuin init zsh --disable-up-arrow)"

# zinit ice as"command" from"gh-r" \
#           atclone"./starship init zsh > init.zsh; ./starship completions zsh > _starship" \
#           atpull"%atclone" src"init.zsh"
# zinit light starship/starship
eval "$(starship init zsh)"

## コマンド補完
zinit light zsh-users/zsh-completions
# autoload -Uz compinit && compinit

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

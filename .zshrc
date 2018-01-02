
# (d) is default on

# ------------------------------
# General Settings
# ------------------------------
export EDITOR=vim        # エディタをvimに設定
export LANG=ja_JP.UTF-8  # 文字コードをUTF-8に設定
export KCODE=u           # KCODEにUTF-8を設定
export AUTOFEATURE=true  # autotestでfeatureを動かす

bindkey -e               # キーバインドをemacsモードに設定
#bindkey -v              # キーバインドをviモードに設定
set modifiable
set write
set clipboard=
setopt no_beep           # ビープ音を鳴らさないようにする
setopt auto_cd           # ディレクトリ名の入力のみで移動する
setopt auto_pushd        # cd時にディレクトリスタックにpushdする
setopt PUSHD_IGNORE_DUPS # 重複するdirはpushdしない
setopt correct           # コマンドのスペルを訂正する
setopt magic_equal_subst # =以降も補完する(--prefix=/usrなど)
setopt prompt_subst      # プロンプト定義内で変数置換やコマンド置換を扱う
setopt notify            # バックグラウンドジョブの状態変化を即時報告する
setopt equals            # =commandをcommand: shell built-in commandと同じ処理にする

### Complement ###
autoload -U compinit; compinit # 補完機能を有効にする
setopt auto_list               # 補完候補を一覧で表示する(d)
setopt auto_menu               # 補完キー連打で補完候補を順に表示する(d)
setopt list_packed             # 補完候補をできるだけ詰めて表示する
setopt list_types              # 補完候補にファイルの種類も表示する
bindkey "^[[Z" reverse-menu-complete  # Shift-Tabで補完候補を逆順する("\e[Z"でも動作する)
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' # 補完時に大文字小文字を区別しない

### Glob ###
#setopt extended_glob # グロブ機能を拡張する
#unsetopt caseglob    # ファイルグロブで大文字小文字を区別しない

### History ###
HISTFILE=~/.zsh_history   # ヒストリを保存するファイル
HISTSIZE=10000            # メモリに保存されるヒストリの件数
SAVEHIST=10000            # 保存されるヒストリの件数
setopt bang_hist          # !を使ったヒストリ展開を行う(d)
setopt extended_history   # ヒストリに実行時間も保存する
setopt hist_ignore_dups   # 直前と同じコマンドはヒストリに追加しない
setopt share_history      # 他のシェルのヒストリをリアルタイムで共有する
setopt hist_reduce_blanks # 余分なスペースを削除してヒストリに保存する

# マッチしたコマンドのヒストリを表示できるようにする
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

# すべてのヒストリを表示する
function history-all { history -E 1 }

#------------------------------
# 補完関連
# -----------------------------
autoload -U compinit
compinit
zstyle ':completion:*:default' menu select=1

# ------------------------------
# Look And Feel Settings
# ------------------------------
### Ls Color ###
# 色の設定
export LSCOLORS=Exfxcxdxbxegedabagacad
# 補完時の色の設定
export LS_COLORS='di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
# ZLS_COLORSとは？
export ZLS_COLORS=
# lsコマンド時、自動で色がつく(ls -Gのようなもの？)
export CLICOLOR=true
# 補完候補に色を付ける
zstyle ':completion:*:default' list-colors
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

### Prompt ###
# プロンプトに色を付ける
autoload -U colors; colors

function rprompt-git-current-branch {
    local name st color

    if [[ "$PWD" =~ '/\.git(/.*)?$/' ]]; then
        return
    fi

    name=$(basename "`git symbolic-ref HEAD 2> /dev/null `")
    if [[ -z $name ]];then
        return
    fi

    st=`git status 2> /dev/null`

    if [[ -n `echo "$st" |  grep "^nothing to"` ]];then
        color=${fg[green]}
    elif [[ -n `echo "$st" | grep "^nothing added"` ]];then
        color=${fg[yellow]}
    elif [[ -n `echo "$st" | grep "^Untracked"` ]];then
        color=${fg[yellow]}
    else
        color=${fg[red]}
    fi

    repo=`git config -l | grep ^remote | grep url |sed -e 's/.*=//' | sed -e 's/.git$//' | sed -e 's/:/\//' |sed -e 's/git@/https:\/\//' | sed -e 's/https\/\/\//https:\/\//'`
    echo "%{$color%}[$repo/tree/$name]%{$reset_color%}"
}

function jobslist()
{
    #settings
    title_c="%K{28}"
    title_c_fg="%F{-1}"
    job_c="%K{28}"
    col_reset="%K{-1}%F{-1}"

    all_job=`jobs | grep -v "pwd now"`
    jobcnt=` echo $all_job |grep -v '^$' | wc -l`
    jobcnt=`printf "%d" $jobcnt`
    jobcnt="%{${title_c}%}Job:${jobcnt}%{${title_c_fg}${job_c}%}>%{%F{-1}%}"

    echo $all_job | while read job
    do
        if [ "$all_job" = "" ];then
            continue
        fi

        jobnum=`echo $job | sed -e 's/\[\([[0-9]*\)]*\][[:blank:]]*\(.\)[[:blank:]]*\([A-Z,a-z]*\)[[:blank:]]*\(.*$\)/\1/'`
        jobcurrent=`echo $job | sed -e 's/\[\([[0-9]*\)]*\][[:blank:]]*\(.\)[[:blank:]]*\([A-Z,a-z]*\)[[:blank:]]*\(.*$\)/\2/'`
        jobstatus=`echo $job | sed -e 's/\[\([[0-9]*\)]*\][[:blank:]]*\(.\)[[:blank:]]*\([A-Z,a-z]*\)[[:blank:]]*\(.*$\)/\3/'`
        jobname=`echo $job | sed -e 's/\[\([[0-9]*\)]*\][[:blank:]]*\(.\)[[:blank:]]*\([A-Z,a-z]*\)[[:blank:]]*\(.*$\)/\4/'`
        color=${fg[yellow]}

        if [ "$jobstatus" = "suspended" ];then
            color=${fg[red]}
        fi
        if [ "$jobstatus" = "running" ];then
            color=${fg[green]}
        fi
        if [ "$jobcurrent" = "+" ];then
            color=$color${bg_no_bold[white]}
        fi
        if [ "$jobcurrent" = "-" ];then
            color=$color${bg_no_bold[cyan]}
        fi

        jobcnt="${jobcnt}%%${jobnum}:$jobname > "
    done
    echo "${jobcnt}%{${col_reset}%}"
}

function spwd () {
    # Shorten the path of pwd
    shortpwd=`pwd | \
    perl -pe 's!$ENV{"HOME"}!~!;s!^(.{10,}?/)(.+)(/.{15,})$!$1...$3!'`
    echo $shortpwd
}

# 一般ユーザ時
tmp_prompt="
\$(rprompt-git-current-branch)
%K{28}\$(date "+%Y/%m/%d-%H:%M:%S")>%{${reset_color}%} \$(jobslist)
"
tmp_prompt2="%{${fg[cyan]}%}%_> %{${reset_color}%}"
tmp_rprompt="%{${fg[green]}%}[%~]%{${reset_color}%}"
tmp_sprompt="%{${fg[yellow]}%}%r is correct? [Yes, No, Abort, Edit]:%{${reset_color}%}"

col_host="%K{28}"
col_hostf="%F{-1}"
col_pwd="%K{28}"
col_reset="%K{-1}%F{-1}"

PROMPT=$tmp_prompt    # 通常のプロンプト
PROMPT2=$tmp_prompt2  # セカンダリのプロンプト(コマンドが2行以上の時に表示される)
#RPROMPT=$tmp_rprompt  # 右側のプロンプト
SPROMPT=$tmp_sprompt  # スペル訂正用プロンプト

#RPROMPT='$(rprompt-git-current-branch)%{%K{0}${reset_color}%}'

# SSHログイン時のプロンプト
[ -n "${REMOTEHOST}${SSH_CONNECTION}" ] &&
      PROMPT="${PROMPT}%{${col_host}${col_hostf}%}${HOST%%.*}%{${col_pwd}${col_hostf}%}> %{${reset_color}%}"
;

#pwd
  PROMPT="${PROMPT}%{${col_pwd}%}%(3~,%-1~>...>%2~,%~)%{${reset_color}%}"
  PROMPT="${PROMPT}%{${fg[cyan]}%} %# %{${col_reset}${reset_color}%}"


### Title (user@hostname) ###
case "${TERM}" in
    (kterm*|xterm*|)
        precmd() {
            echo -ne "\033]0;${USER}@${HOST%%.*}\007"
        }
        ;;
esac

# ------------------------------
# Other Settings
# ------------------------------
### RVM ###
if [[ -s ~/.rvm/scripts/rvm ]] ; then source ~/.rvm/scripts/rvm ; fi

### Macports ###
PATH=/sbin:/bin/:$PATH
case "${OSTYPE}" in
    darwin*)
        export PATH=~/.rbenv/shims/:$PATH
        export PATH=/opt/local/bin:/opt/local/sbin:$PATH
        export PATH=/Applications/MAMP/bin/php/php5.5.10/bin/:$PATH
        export MANPATH=/opt/local/share/man:/opt/local/man:$MANPATH
        ;;
esac
export PATH=/usr/local/opt/coreutils/libexec/gnubin:$PATH

export PATH=$HOME/Library/Android/sdk/platform-tools/:/usr/local/bin:/usr/local/sbin:$PATH
export PYTHONPATH=/usr/local/lib/python2.7/site-packages/

export PATH=$(brew --prefix coreutils)/libexec/gnubin:$PATH
export PATH=$(brew --prefix gnu-sed)/bin:$PATH
export PATH=~/.pyenv/shims:$PATH


#///////////////////////////////////////////////////////////////////////////////////
# ----------------------------------
# USER CONF
# ----------------------------------
#///////////////////////////////////////////////////////////////////////////////////

export PATH=~/bin/:$PATH:$HOME/dot_config/bin/

#git update

if [ -e ~/dot_config/.zshrc ];then
  pushd $HOME/dot_config
    git pull
  popd
fi

### colordiff

### Aliases ###
alias r=rails
alias v=vim
alias diff=colordiff
alias ls='ls --color=auto'
alias grep='grep --color=always'
alias l='ls'
alias ltr='ls -ltr'

function ssh_zsh()
{
    hostname=`echo "$*" | sed -e 's/^-[-,0-9,a-z,A-Z]*//g;s/ -[-,0-9,a-z,A-Z]*//g;s/ //g'`
    echo "connect to $hostname with ssh..."

    rc=`\ssh $* "ls -a ~/.zshrc" 2>&1 | grep "No such file"`
    if [ "$rc" != "" ] ; then
        echo ".zshrc check .... FAILD"
        echo "Sync .zshrc to $hostname"
        scp ~/.zshrc  $hostname:~/.zshrc
    else
        echo ".zshrc check .... OK"
    fi

    no_update=`\ssh $* "ls -a ~/dot_config/.zshrc" 2>&1 | grep "No such file"`
    if [ "x$no_update" != "x" ] ; then
        echo "git check .... FAILD"
        echo "Sync .zshrc to $hostname"
        scp ~/.zshrc  $hostname:~/.zshrc
    else
        echo ".no_auto_update check .... OK"
    fi
    ssh -A $*
}


alias ssh=ssh_zsh
compdef ssh_zsh=ssh


#git submodule
function git-root() {
    if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
        cd `pwd`/`git rev-parse --show-cdup`
    fi
}

function submoduleUpdate() {
    now=`pwd`
    git-root
    git submodule init
    git submodule sync
    git submodule update
    cd $now
}

function smart_mv()
{
    sts=`git status 2>&1 | grep 'Not a git repository' `
    if [[ "${sts}" != "" ]]; then
        mv $*
        return
    fi
    git mv $*
}
alias mv=smart_mv




alias relogin='exec zsh -l'
alias php='php -dopen_basedir=/ '
alias rmswp='find . -name "*.swp" -exec rm {} \;'
alias iOScurl="curl -A 'Mozilla/5.0 (iPhone; CPU iPhone OS 6_0 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10A403 Safari/8536.25'"


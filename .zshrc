
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

setopt no_beep           # ビープ音を鳴らさないようにする
setopt auto_cd           # ディレクトリ名の入力のみで移動する 
setopt auto_pushd        # cd時にディレクトリスタックにpushdする
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
setopt extended_glob # グロブ機能を拡張する
unsetopt caseglob    # ファイルグロブで大文字小文字を区別しない

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
	local name st color wd

	wd="%{${fg[green]}%}$(basename `pwd` )%{$reset_color%}"
	if [[ "$PWD" =~ '/\.git(/.*)?$/' ]]; then
		echo "[${wd}]"
		return
	fi
	

	name=$(basename "`git symbolic-ref HEAD 2> /dev/null `")
	if [[ -z $name ]];then
		echo "[${wd}]"
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
	echo "%{${fg[cyan]}%}[%~]%{$reset_color%}[%{$color%}$name%{$reset_color%}]"
}

function jobslist()
{
	all_job=`jobs | grep -v "pwd now"`
	jobcnt=` echo $all_job |grep -v '^$' | wc -l`
	jobcnt=`printf "%d" $jobcnt`
	jobcnt="[%{${fg[cyan]}%}${jobcnt}%{${reset_color}%}]"
	
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

		jobcnt="${jobcnt}%{${color}%}%%${jobnum}:$jobname%{${reset_color}%}|"
	done
	echo $jobcnt
}
# 一般ユーザ時



tmp_prompt="
\$(jobslist)
[%{${fg[green]}%}%~%{${reset_color}%}]
%{${fg[cyan]}%}%# %{${reset_color}%}"
tmp_prompt2="%{${fg[cyan]}%}%_> %{${reset_color}%}"
tmp_rprompt="%{${fg[green]}%}[%~]%{${reset_color}%}"
tmp_sprompt="%{${fg[yellow]}%}%r is correct? [Yes, No, Abort, Edit]:%{${reset_color}%}"


# rootユーザ時(太字にし、アンダーバーをつける)

if [ ${UID} -eq 0 ]; then
	tmp_prompt="%B%U${tmp_prompt}%u%b"
	tmp_prompt2="%B%U${tmp_prompt2}%u%b"
	tmp_rprompt="%B%U${tmp_rprompt}%u%b"
	tmp_sprompt="%B%U${tmp_sprompt}%u%b"
fi


if [ 2009307072 -eq 0 ]; then
  tmp_prompt="%B%U%u%b"
  tmp_prompt2="%B%U%u%b"
  tmp_rprompt="%B%U%u%b"
  tmp_sprompt="%B%U%u%b"
fi

PROMPT=$tmp_prompt    # 通常のプロンプト
PROMPT2=$tmp_prompt2  # セカンダリのプロンプト(コマンドが2行以上の時に表示される)
RPROMPT=$tmp_rprompt  # 右側のプロンプト
SPROMPT=$tmp_sprompt  # スペル訂正用プロンプト

RPROMPT='$(rprompt-git-current-branch)'

# SSHログイン時のプロンプト
[ -n "${REMOTEHOST}${SSH_CONNECTION}" ] &&
	  PROMPT="%{${fg[white]}%}${HOST%%.*}@${PROMPT}"
;


### Title (user@hostname) ###

case "${TERM}" in
	kterm*|xterm*|)
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

case "${OSTYPE}" in
	darwin*)
		export PATH=/opt/local/bin:/opt/local/sbin:$PATH
		export MANPATH=/opt/local/share/man:/opt/local/man:$MANPATH
		;;
esac

export PATH=$HOME/bin:$PATH:/bin/:/sbin/:/usr/sbin/:/usr/bin
export PYTHONPATH=/usr/local/lib/python2.7/site-packages/

### Aliases ###
alias r=rails
alias v=vim
#alias ssh='ssh $* -A -t zsh'

# cdコマンド実行後、lsを実行する
#function cd() {
#  builtin cd  && ls;
#}


function ssh_zsh()
{
	ssh $* -t zsh
}
alias ssh=ssh_zsh



#export PYENV_ROOT="$HOME/.pyenv"
#export PATH="$PYENV_ROOT/bin:$PATH"
#eval "$(pyenv init -)"
#eval "$(pyenv virtualenv-init -)"

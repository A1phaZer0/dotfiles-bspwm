###
#  history 
###

#  ignore duplicate lines or lines starting with space
HISTCONTROL=ignoreboth

#  append to history file, not overwrite it.
shopt -s histappend

#  set history size
HISTSIZE=1000
HISTFILESIZE=2000

###
#  prompt and completion
###

source ~/.config/git-prompt/git-prompt.sh
source ~/.config/git-prompt/git-completion.bash

#  \u user, \w working directory

#  regular

BLACK="\[\e[0;30m\]"
RED="\[\e[0;31m\]"
GREEN="\[\e[0;32m\]"
YELLOW="\[\e[0;33m\]"
BLUE="\[\e[0;34m\]"
PURPLE="\[\e[0;35m\]"
CYAN="\[\e[0;36m\]"
WHITE="\[\e[0;37m\]"

#  bold

BBLACK="\[\e[1;30m\]"
BRED="\[\e[1;31m\]"
BGREEN="\[\e[1;32m\]"
BYELLOW="\[\e[1;33m\]"
BBLUE="\[\e[1;34m\]"
BPURPLE="\[\e[1;35m\]"
BCYAN="\[\e[1;36m\]"
BWHITE="\[\e[1;37m\]"

#  color off

COFF="\[\e[0m\]"

#  colorize git_ps1

colorize() 
{
	if [[ $EUID == 0 ]]; then
		PS1='\u@\h:\W \$ '
	else
		# 'Not' or 'not' depends on different version of git
		local is_rep=$(echo `git status 2>&1` | grep -o "Not a git repository" )
		local INFO="$BGREEN\u$BBLUE@$BGREEN\h:$BCYAN\w"
		if [[ ${#is_rep} -eq 0 ]]; then
			local git_status=$(__git_ps1 "%s")
			local rep_clean=$(echo `git status` | grep -o "nothing to commit")
			local untracked=$(echo `git status` | grep -o "Untracked")
			if [[ ${#rep_clean} -ne 0 ]]; then ## repository is clean;
				local GIT=$BGREEN$git_status=$COFF
			elif [[ ${#untracked} -ne 0 ]]; then ## untracked file presents
				local GIT=$BPURPLE$git_status+$COFF
			else
				local GIT=$BYELLOW$git_status*$COFF
			fi
		else ## not a git repository
			local GIT=$COFF
		fi
		PS1="$INFO $GIT \$ "
	fi
}

PROMPT_COMMAND=colorize

###
#  aliases
###
alias ls='ls --color=auto'
alias grep='grep --colour=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias ll='ls -alF'
alias la='ls -A'
alias xo='xdg-open'
alias pxc='proxychains4'


###
#  ranger
###

#  not load default rc.conf, load ~/.config/ranger/rc.conf
export RANGER_LOAD_DEFAULT_RC=FALSE

###
#  Operating System Controls (OSC)
###

#  ESC P: DEVICE Control String, outputs a string directly to the host
#+ terminal without interpretation. ST is string terminator.
#  DCS = \033P ST = \033\
#  vt100 responds to OSC only when it's from output. so use echo/printf
#  An OSC string starts with ESC ] m to set different terminal properties,
#+ and use BEL(\007) to terminate an OSC string.
#  So,for vt100/vt220, to set color beyond 15, just:
#  echo -ne "\033P\033]4;color_index;rgb:rr/gg/bb\007\033\\"
#  for xterm/urxvt, do:
#  echo -ne "\033]4;color_index;rgb:rr/gg/bb\033\\"
printf "\033]4;16;rgb:FF/92/EB\033\\"
printf "\033]4;17;rgb:36/D6/46\033\\"
printf "\033]4;18;rgb:19/B0/A1\033\\"
printf "\033]4;19;rgb:FF/7A/00\033\\"
printf "\033]4;20;rgb:BA/A3/9C\033\\"
printf "\033]4;21;rgb:AB/6C/FF\033\\"
printf "\033]4;22;rgb:69/C7/81\033\\"
printf "\033]4;23;rgb:9C/B3/BA\033\\"
printf "\033]4;24;rgb:00/D5/FF\033\\"

function ta ()
{
    #clean older info
    rm -rf tags
    rm -rf cscope.files
    rm -rf cscope.out
    # generate new info
    find $PWD | egrep -i "\.(c|h|cpp)$" > cscope.files
    #ctags -R . *.c *.h *.cpp --tag-relative=no ./
    cscope -R -b
    export CSCOPE_DB=$PWD/cscope.out
}

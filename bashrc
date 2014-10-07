# /etc/skel/.bashrc
#
# This file is sourced by all *interactive* bash shells on startup,
# including some apparently interactive shells such as scp and rcp
# that can't tolerate any output.  So make sure this doesn't display
# anything or bad things will happen !


# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]] ; then
	# Shell is non-interactive.  Be done now!
	return
fi


# Put your fun stuff here.

alias grep='grep --color=auto'
alias ls='ls --color=auto'
alias ll='ls -lh'
alias la='ll -A'

export HISTCONTROL="$HISTCONTROL ignoredups"

BLACK="\[\e[30m\]"
BLACK_HI="\[\e[90m\]"
RED="\[\e[31m\]"
RED_HI="\[\e[91m\]"
GREEN="\[\e[32m\]"
GREEN_HI="\[\e[92m\]"
BLUE="\[\e[34m\]"
BLUE_HI="\[\e[94m\]"
WHITE="\[\e[37m\]"
WHITE_HI="\[\e[97m\]"
RESET="\[\e[0m\]"

COLOR=${GREEN_HI}
BRACKETS=${BLACK_HI}

gitprompt="$HOME/code/bash-git-prompt/gitprompt.sh"
if [[ -f $gitprompt ]] ; then
    export PS1="$BRACKETS\t $COLOR\u$BRACKETS@$WHITE\h$BRACKETS:$WHITE_HI\w\$($gitprompt) $COLOR\$ $RESET"
else
    export PS1="$BRACKETS\t $COLOR\u$BRACKETS@$WHITE\h$BRACKETS:$WHITE_HI\w $COLOR\$ $RESET"
fi

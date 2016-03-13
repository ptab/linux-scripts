#!/bin/bash

# aliases
alias less="less -R"
alias ll="ls -lhpG"
alias la="ll -A"
alias ack-src="ack --ignore-dir=target --ignore-dir=.idea --ignore-file=ext:iml --ignore-file=ext:log"
alias ack-src-no-tests="ack-src --ignore-dir=test"
alias ack-jvm="ack-src --java --scala"
alias ack-jvm-no-tests="ack-jvm --ignore-dir=test"
alias ack-pom="ack-src --pom"
alias deps="mvn dependency:tree | less"
alias idea-clean='find $HOME/dev/aurora/ -name ".idea" | egrep -v "Aurora|Tests|Thrift|pipeline-" | xargs rm -rf'

# PS1

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
    export PS1="$BRACKETS\t $COLOR\u$BRACKETS:$WHITE_HI\w\$($gitprompt) $COLOR\$ $RESET"
else
    export PS1="$BRACKETS\t $COLOR\u$BRACKETS:$WHITE_HI\w $COLOR\$ $RESET"
fi

export PROMPT_COMMAND='echo -ne "\033]0;${PWD/#$HOME/~}\007"'

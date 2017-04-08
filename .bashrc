# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# General {{{ ------------------------------------------------------------------
# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
# }}}
# Environment Variables {{{ ----------------------------------------------------

# Update shell to use base16 color scheme
BASE16_SHELL=$HOME/.config/base16-shell
[ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"

# add user's bin to path
export PATH="$PATH:$HOME/bin"

# use vim as editor
export EDITOR=vim

# set less's options
#  -s: combine consequtive blank lines into one
#  -R: output raw ANSI color escape sequences
#  -i: ignore case unless an uppercase exists in search pattern
export LESS=-csri
# }}}
# Prompt {{{ -------------------------------------------------------------------
# Color Escape Sequences
#
# Colors and style ayytibutes are defined by escape sequences. The charts 
# below give the foreground (fg) and background (bg) codes for each color, 
# aswell as the codes for each style.
#
#   color     fg   bg           style       s
#   -------   --   --           ----------  -
#   black     30   40           reset       0
#   red       31   41           bold        1
#   green     32   42           dim         2
#   yellow    33   43           underscore  4
#   blue      34   44           blink       5
#   magenta   35   45           reverse     7
#   cyan      36   46           hidden      8
#   white     37   47       
#
# To a apply single attribute, insert the desired attibutes code into the 
# template below at the XX marks. More than one attribute can be applied in
# a single sequence by separating them with semicolons. 
#
# template: \[\e[XXm\]
#
# It is important to match each sequence with a closing reset sequence to 
# clear the attributes and ensure that any proceeding text is not affected 
# by the color/style. Below is an example:
#
#   underlined white text on a blue background:
#       \[\e[0;4;37;44m\]Hello world!\[e[0m\]
#

# foreground color escape sequences
red="\e[31m"
green="\e[32m"
yellow="\e[33m"
blue="\e[34m"
magenta="\e[35m"
cyan="\e[36m"
white="\e[37m"
grey="\e[90m"

# attribute escape sequences
reset="\e[0m"
bold="\e[1m"
dim="\e[2m"
italics="\e[3m"
underline="\e[4m"
blink="\e[5m"

LAST_EXIT=0
__ps1_main_color=$green
__ps1_pwd=$(dirs -0)
__ps1_proc=$(ps -p $$ -o comm=)

__ps1_cmd()
{
    LAST_EXIT="$?"

    if (( $LAST_EXIT != 0 )); then
        __ps1_main_color=$red
    else
        __ps1_main_color=$green
    fi

    __ps1_pwd=$(dirs -0)
}
__ps1_titlebar()
{
    printf "\e]2;urxvt [$__ps1_pwd]\a"
}
__ps1_rightinfo()
{
    local connector=""
    for ((i=0; i<1+$COLUMNS/4; ++i)); do
        connector+="────"
    done

    local jobscount=$(( $(jobs | wc -l) - 1))
    local jobsinfo=""
    if (( $jobscount > 0 )); then
        jobsinfo="jobs:$jobscount"
    fi

    local exitinfo=""
    if (( $LAST_EXIT != 0 )); then
        exitinfo="exit:$LAST_EXIT"
    fi

    if [[ $jobsinfo != "" && $exitinfo != "" ]]; then
        jobsinfo+="║"
    fi

    local info="${connector}╢${jobsinfo}${exitinfo}╟╼"

    printf "%b%*s%b" $__ps1_main_color $COLUMNS "${info:(-$COLUMNS)}" $reset
}
__ps1_leftinfo()
{
    printf "$__ps1_main_color┌[$white$__ps1_pwd$__ps1_main_color]$reset"
}
__ps1_prompt()
{
    printf "$__ps1_main_color$bold└>$reset"
}

ps1_main()
{
    # titlebar
    PS1="\[\$(__ps1_titlebar)\]"
    # info row right
    PS1+="\[\$(tput sc; __ps1_rightinfo; tput rc)\]"
    # info row left
    PS1+="\[\$(__ps1_leftinfo)\]"
    # input row
    PS1+="\[\n\]\[\$(__ps1_prompt)\] "
    export PS1
}
ps1_minimal()
{
    PS1="\w \$ "
}
ps1_off()
{
    PS1='\$ '
}

PROMPT_COMMAND=__ps1_cmd
ps1_main

# }}}
# History {{{ ------------------------------------------------------------------
# don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000
# }}}
# Aliases {{{ ------------------------------------------------------------------

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

alias sbrc="source ~/.bashrc"
alias ebrc="vim ~/.bashrc"

alias xup="xrdb ~/.Xresources"

alias ls='ls --color=auto --block-size=M'
alias ll='ls -l'
alias la='ls -a'
alias lla='ls -la'

alias mkdir="mkdir -pv"

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias svim="sudoedit"

alias tmux="tmux -2"
alias tmuxa="tmux -2 attach"

alias lscm="mit-scheme -load"
alias lscmu="mit-scheme -load ~/cs403/scheme/util.scm"

alias ghci_="ghci-7.10.3 +RTS -V0"

alias star_wars="telnet towel.blinkenlights.nl"

alias pipes_ultra="pipes.sh -B -p 9 -f 20 -t 0"
alias pipes_fastest="pipes.sh -f 20"

alias colortest="~/.config/base16-shell/colortest base16-tomorrow-night.sh"

# }}}
# Custom Functions {{{ ---------------------------------------------------------

# make a new directory an then change to that directory
mkcd ()
{
    mkdir "$1"
    cd "$1"
}

# cd into directory then ls
cdl ()
{
    cd "$1"
    ls
}

prolog ()
{
    args=""
    if [ "$#" -gt 0 ]; then
        args+="--entry-goal \""
        for pl in "$@"; do 
            args+="[""'""$pl""'""], "
        done
        args="${args::-2}\""
    fi
    echo "gprolog $args"
    eval "gprolog $args"
}


wait_for_input ()
{
    tput civis          # hide cursor
    read -n 1 -s -p " " # wait for keystroke
    tput cnorm          # show cursor
    printf "\r"
}

rest ()
{
    clear
    wait_for_input
}

# }}}
trap 'printf "\033]0;%s\007" "${BASH_COMMAND//[^[:print:]]/}"' DEBUG
# vim:foldmethod=marker:foldlevel=0

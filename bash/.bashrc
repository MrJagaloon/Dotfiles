# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# General {{{ ------------------------------------------------------------------
# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Update shell to use base16 color scheme
BASE16_SHELL=$HOME/.config/base16-shell
[ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"

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
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# add user's bin to path
export PATH="$PATH:$HOME/bin"

# use vim as editor
export EDITOR=vim
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
#   red       31   41           bright      1
#   green     32   42           dim         2
#   yello     33   43           underscore  4
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

# declare prompt color variables
declare -A PROMPT_COLOR
export PROMPT_COLOR

# declare prompt sections
export PSEC_CWD
export PSEC_CWP
export PSEC_JOBS
export PSEC_EXIT
export PCOL_PRIV
export EXIT

#PROMPT_COMMAND=__prompt_command
__prompt_command ()
{
    # The prompt has 3 lines with the following format:
    #   line 1: status line showing exit status (if error) and number of
    #           running jobs, 
    #   line 2: the PWD, with $HOME replaced by tilde (~)
    #   line 3: an arrow (>) colored to indicate the users current priveledge
    #           (red=root, yellow=sudo, white=user); commands are entered after
    #           the arrow.
    #

    # exit status section
    EXIT="$?"
    PSEC_EXIT=""
    # If last cmd returned error, add the exit code
    [[ $EXIT != 0 ]] && PSEC_EXIT="[${EXIT}]"

    # jobs section
    PSEC_JOBS=""
    local jobc=$(jobs | wc -l)
    [[ $jobc > 0 ]] && PSEC_JOBS="{$jobc}"

    # CWD section
    PSEC_CWD=""
    PSEC_CWP=""
    # The PWD is formated to replace $HOME with tilde (~)
    local new_pwd="${PWD/#$HOME/'~'}"
    # If not at home, add the CWD path
    [[ $PWD != $HOME ]] && PSEC_CWP="${new_pwd%/*}/"

    PSEC_CWD="${new_pwd##*/}"
    # priveledge color section
    local root_color="\[\e[31m\]"          # red
    local user_color="\[\e[32m\]"          # green
    local sudo_color="\[\e[33m\]"          # yellow
    PCOL_PRIV="$user_color"
    if   [[ $EUID == 0 ]]; then PCOL_PRIV="${root_color}"
    elif [[ $SUDO_USER ]]; then PCOL_PRIV="${sudo_color}"
    fi
}

get_psec_exit ()
{
    printf "%s" "$PSEC_EXIT"
}

prompt_full ()
{
    export PROMPT_COMMAND=__prompt_command

    local PCOL_NIL="\[\e[0m\]"     # clear
    local PCOL_DEF="\[\e[37m\]"    # white
    local PCOL_CWP="\[\e[1;37m\]"  # grey CWD Path
    local PCOL_CWD="\[\e[1;37m\]"  # grey 
    local PCOL_ERR="\[\e[31m\]"    # red
    local PCOL_JOBS="\[\e[36m\]"   # cyan

    PS1="${PCOL_ERR}$(get_psec_exit)${PCOL_NIL}${PCOL__JOBS}${PSEC_JOBS}${PCOL_NIL}\n"
    PS1+="${PCOL_CWP}${PSEC_CWP}${PCOL_NIL}${PCOL_CWD}${PSEC_CWD}${PCOL_NIL}\n"
    PS1+="${C_PRIV}>${C_NIL} "

    export PS1
}
prompt_minimal ()
{
    unset PROMPT_COMMAND
    PS1="\w:\n> "
}
prompt_off ()
{
    unset PROMPT_COMMAND
    PS1='\$ '
}

prompt_minimal
# }}}
# Aliases {{{ ------------------------------------------------------------------

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

alias sbrc="source ~/.bashrc"
alias ebrc="vim ~/.bashrc"

alias xup="xrdb ~/.Xresources"

alias ls='ls --color=auto'
alias ll='ls -l'
alias la='ls -a'
alias lla='ls -la'

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias agi='sudo apt install'

alias svim="sudoedit"

alias tmux="tmux -2"
alias tmuxa="tmux -2 attach"

alias pipes_ultra="pipes.sh -B -p 9 -f 20 -t 0"
alias pipes_fastest="pipes.sh -f 20"

alias ref_shellkeys="less ~/references/bash_shortcuts"
alias ref_vimkeys="less ~/references/vim_shortcuts"

alias lscm="mit-scheme -load"
alias lscmu="mit-scheme -load ~/cs403/scheme/util.scm"

alias ghci_="ghci-7.10.3 +RTS -V0"

alias star_wars="telnet towel.blinkenlights.nl"
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

# vim:foldmethod=marker:foldlevel=0

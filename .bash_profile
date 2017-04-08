#
# ~/.bash_profile
#

# load user's bashrc
[[ -f ~/.bashrc ]] && . ~/.bashrc

# start xorg
export DISPLAY=:0.0
if [ -n "$DISPLAY" ] && [ -n "$XDG_VTNR" ] && [ "$XDG_VTNR" -eq 1 ]; then
    exec startx
fi

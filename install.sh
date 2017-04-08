#!/bin/bash

# Install/uninstall the dotfiles/directories in ~/etc/ to ~/ with symlinks.

uninstall=false
verbose=false
dot_dir="$HOME/etc"

# Dotfiles to be dotified
declare -a DOTS
# bash
dots+=(".bash_profile" ".bash_logout" ".bashrc" ".dircolors")
# vim
dots+=(".vimrc")
# X11
dots+=(".xinitrc" ".Xresources")
# i3
dots+=(".i3")
# ranger
dots+=(".config/ranger")


main()
{
    while getopts hvD opt; do
        case $opt in
            h) usage ;;
            v) verbose=true ;;
            D) uninstalL=true ;;
        esac
    done

    if $verbose; then
        if $uninstall; then
            echo "Unstalling dotfiles in $dot_dir from $HOME"
        else
            echo "Installing dotfiles in $dot_dir to $HOME"
        fi
    fi

    for ((i=0; i<${#dots[@]}; ++i)); do
        dotify "${dots[i]}"
    done
}

# If installing, creates a symlink of arg1 in $HOME
# If unstalling, removes the symlink of arg1 in $HOME
# Fails if arg1 is not found in ~/etc
# arg1 is the name of the dotfile/directory to be dotified
dotify()
{
    if [ -z "$dot_dir/$1" ]; then echo "Dotfile not found: $1"
    elif $uninstall; then 
        rm -rf "$HOME/$1"
        if $verbose; then echo "Removed $1 from $HOME"; fi
    else 
        rm "$HOME/$1"
        ln -sf "$dot_dir/$1" "$HOME/$1"
        if $verbose; then echo "Linked $1 to ~/$1"; fi
    fi
}

usage()
{
    echo "Usage: ./install.sh [-hvD]"
    echo "Options:"
    echo "  -h      show this help"
    echo "  -v      verbose"
    echo "  -D      uninstall"
    exit 0
}

main "$@"

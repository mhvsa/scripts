#!/usr/bin/env bash
# Description: A script to search for cheat sheets using cht.sh, fzf, and bat.
# Inspired by: The script is inspired by the tmux-cht.sh script by @ThePrimeagen.
# Dependencies: curl, fzf, bat
# Author: @mhvsa
# License: MIT
# Version: 1.0.0

# Print the help message.
if [[ $# -eq 1 ]] && [[ $1 == "--help" ]]; then
    echo "Usage: tmux-cht.sh [OPTION] [QUERY]"
    echo "A script to search for cheat sheets using cht.sh, fzf, and bat."
    echo ""
    echo "Options:"
    echo "  --help    Show this help message."
    echo ""
    echo "Examples:"
    echo "  tmux-cht.sh                        # Select a language or command from a list of languages and commands."
    echo "  tmux-cht.sh --help                 # Show this help message."
    exit 0
fi

# If the config directory doesn't exist, then create it.
if [[ ! -d ~/.config/tmux-cht.sh ]]; then
    # Create config directory.
    mkdir -p ~/.config/tmux-cht.sh
    # Create languages file.
    touch ~/.config/tmux-cht.sh/languages
    # Create command file.
    touch ~/.config/tmux-cht.sh/command
fi

# Select the language or command to search for. Use the XDG Base Directory Specification to store the languages and command files.
selected=`cat ~/.config/tmux-cht.sh/languages ~/.config/tmux-cht.sh/command | fzf --height 20% --layout=reverse --prompt="Select Language or Command: "`
if [[ -z $selected ]]; then
    # Inform the user that language or command doesn't exist. Ask the user
    # if they want to add the language or command to the languages or command.
    read -p "Language or command doesn't exist. Do you want to add it? [y/n]: " add
    if [[ $add == "y" ]]; then
        read -p "Enter language or command: " language
        read -p "Is it a language or command? [l/c]: " type
        if [[ $type == "l" ]]; then
            echo $language >> ~/.config/tmux-cht.sh/languages
        elif [[ $type == "c" ]]; then
            echo $language >> ~/.config/tmux-cht.sh/command
        else
            echo "Invalid option."
        fi
    elif [[ $add == "n" ]]; then
        echo "Exiting..."
        exit 0
    else
        echo "Invalid option."
    fi
    exit 0
fi

read -p "Enter Query: " query

# If the selected language is in the languages file and the query is not empty, then open a new window and run the curl command
# with both the selected language and the query. If the query is empty, then open a new window and run the curl command with
# only the selected language. If the selected language is not in the languages file, then open a new window and run the curl
# command with the selected language and the query. The query is then piped to bat to format the output.
if [[ `cat ~/.config/tmux-cht.sh/languages | grep $selected` ]] && [[ ! -z $query ]]; then
    query=`echo $query | tr ' ' '+'`
    tmux neww bash -c "curl -s cht.sh/$selected/$query | bat"
elif [[ `cat ~/.config/tmux-cht.sh/languages | grep $selected` ]] && [[ -z $query ]]; then
    tmux neww bash -c "curl -s cht.sh/$selected | bat"
else
    tmux neww bash -c "curl -s cht.sh/$selected~$query | bat"
fi


#!/usr/bin/env bash
output=$(cat ~/.tmux-cht-languages ~/.tmux-cht-command | fzf --print-query)

query=$(echo "$output" | head -n 1)
selected=$(echo "$output" | tail -n 1)

if [[ -z "$selected" ]]; then
    target="$query"
    is_manual=true
else
    target="$selected"
    is_manual=false
fi

if [[ -z "$target" ]]; then
    exit 0
fi

type_choice=""
if grep -qs "^$target$" ~/.tmux-cht-languages; then
    type_choice="language"
elif grep -qs "^$target$" ~/.tmux-cht-command; then
    type_choice="command"
else
    type_choice=$(echo -e "Language\nCommand" | fzf --header "Select type for '$target':")
    type_choice=$(echo "$type_choice" | tr '[:upper:]' '[:lower:]')
fi

if [[ -z "$type_choice" ]]; then
    exit 0
fi

read -p "Enter Query: " query

if [[ "$type_choice" == "language" ]]; then
    search_formatted=$(echo "$search_input" | tr ' ' '+')
    cmd="curl -s cht.sh/$target/$search_formatted | less -R"
else
    search_formatted=$(echo "$search_input" | tr ' ' '+')
    cmd="curl -s cht.sh/$target~$search_formatted | less -R"
fi

if [ -n "$TMUX" ]; then
    tmux neww bash -c "$cmd"
else
    bash -c "$cmd"
fi

# Setup fzf
# ---------
if [[ ! "$PATH" == */home/tenmo/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/tenmo/.fzf/bin"
fi

source <(fzf --zsh)

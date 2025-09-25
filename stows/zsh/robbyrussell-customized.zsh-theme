PROMPT="%(?:%{$fg_bold[green]%}%1{➜%} :%{$fg_bold[red]%}%1{➜%} ) %{$fg[cyan]%}%~%{$reset_color%}"
PROMPT+=' $(git_prompt_info)'

RPROMPT='%{$fg[blue]%}%*%{$reset_color%}'

setopt PROMPT_SUBST

RPROMPT_ORIG="$RPROMPT"

# show SSH details only when connected over SSH/mosh
if [[ -n "$SSH_CLIENT$SSH_CONNECTION$SSH_TTY" ]]; then
  # client IP (first field of SSH_CLIENT or SSH_CONNECTION)
  local client_ip="${SSH_CLIENT%% *}"
  [[ -z "$client_ip" && -n "$SSH_CONNECTION" ]] && client_ip="${SSH_CONNECTION%% *}"

  RPROMPT="%{$fg_bold[magenta]%}$USER%{$reset_color%}@%{$fg[cyan]%}${client_ip}%{$reset_color%}  ${RPROMPT_ORIG}"
else
  RPROMPT="$RPROMPT_ORIG"
fi

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}%1{✗%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"

#!/usr/bin/env bash

pwd=$(pwd)

cp -rT ~/claudekit-engineer/claude "$pwd/.claude"
cp -r ~/claudekit-engineer/docs/ $pwd/
cp -r ~/claudekit-engineer/plans $pwd/
cp ~/claudekit-engineer/CLAUDE.md $pwd/

gitignore="$pwd/.gitignore"
ignore_items=(
    "# ClaudeKit"
    ".claude/"
    "docs/"
    "plans/"
    "CLAUDE.md"
    "CLAUDE.local.md"
)

if [[ -f "$gitignore" ]]; then
    # make sure appended lines don't get glued to an unterminated last line
    [[ -s "$gitignore" && -n "$(tail -c1 "$gitignore")" ]] && echo >> "$gitignore"

    for item in "${ignore_items[@]}"; do
        grep -qxF -- "$item" "$gitignore" || echo "$item" >> "$gitignore"
    done
fi

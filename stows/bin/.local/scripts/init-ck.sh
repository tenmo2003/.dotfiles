#!/usr/bin/env bash

pwd=$(pwd)

cp -rT ~/claudekit-engineer/claude "$pwd/.claude"
cp -r ~/claudekit-engineer/docs/ $pwd/
cp -r ~/claudekit-engineer/plans $pwd/
cp ~/claudekit-engineer/CLAUDE.md $pwd/

if [[ -f "$PWD/.gitignore" ]] && ! grep -q '.claude' "$PWD/.gitignore"; then
    cat <<EOF >> $pwd/.gitignore
# ClaudeKit
.claude/
docs/
plans/
CLAUDE.md
EOF
fi

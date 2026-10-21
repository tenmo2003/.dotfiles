#!/usr/bin/env bash
set -euo pipefail

kit=~/claudekit-engineer
pwd=$(pwd)

if [[ "$pwd" == "$kit" ]]; then
    echo "init-ck: refusing to run inside the kit repo itself" >&2
    exit 1
fi

# runtime data and archives from the kit's own sessions don't belong in a new project
rsync -a \
    --exclude 'session-state/' \
    --exclude 'command-archive/' \
    --exclude 'hooks/.logs/' \
    --exclude '.env' \
    "$kit/claude/" "$pwd/.claude/"

# the kit's docs/plans describe the kit; the project only needs empty dirs + plan templates
mkdir -p "$pwd/docs" "$pwd/plans/reports"
rsync -a --ignore-existing "$kit/plans/templates/" "$pwd/plans/templates/"

[[ -f "$pwd/CLAUDE.md" ]] || cp "$kit/CLAUDE.md" "$pwd/"

gitignore="$pwd/.gitignore"
ignore_items=(
    "# ClaudeKit"
    ".claude/"
    "docs/"
    "plans/"
    "CLAUDE.md"
    "CLAUDE.local.md"
)

touch "$gitignore"
# make sure appended lines don't get glued to an unterminated last line
[[ -s "$gitignore" && -n "$(tail -c1 "$gitignore")" ]] && echo >> "$gitignore"

for item in "${ignore_items[@]}"; do
    grep -qxF -- "$item" "$gitignore" || echo "$item" >> "$gitignore"
done

echo "ClaudeKit installed in $pwd"
[[ -f "$pwd/.claude/.env" ]] || echo "Next: cp .claude/.env.example .claude/.env and add your API keys"

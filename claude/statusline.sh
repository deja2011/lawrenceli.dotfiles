#!/bin/bash
# Read JSON data from Claude Code
input=$(cat)

# Parse JSON using jq
# Get context used percentage
ctx_used=$(echo "$input" | jq -r '.context_window.used_percentage // 0')
# Calculate remaining percentage
ctx_remaining=$((100 - ${ctx_used%.*}))

# Get model display name, extract short name
model_full=$(echo "$input" | jq -r '.model.display_name // "Unknown"')
# Shorten model name (e.g., "Claude Opus 4" -> "Opus 4")
model=$(echo "$model_full" | sed 's/Claude //')

# Get current time
time=$(date +%H:%M)

# Get username
user=$(whoami)

# Get current directory with ~ shortening
cwd=$(echo "$input" | jq -r '.workspace.current_dir // "."')
dir="${cwd/#$HOME/\~}"

# Plan mode indicator (check if in plan mode from output_style)
output_style=$(echo "$input" | jq -r '.output_style.name // "default"')
if [[ "$output_style" == *"plan"* ]] || [[ "$output_style" == *"Plan"* ]]; then
    plan_indicator="\e[34m[PLAN]\e[0m "
else
    plan_indicator=""
fi

# Todo count - count TODO/FIXME in current project directory
project_dir=$(echo "$input" | jq -r '.workspace.project_dir // "."')
if [[ -d "$project_dir" ]] && command -v rg &> /dev/null; then
    todo_count=$(rg -c "TODO|FIXME" "$project_dir" --no-messages 2>/dev/null | awk -F: '{sum+=$2} END {print sum+0}')
elif [[ -d "$project_dir" ]]; then
    todo_count=$(grep -r "TODO\|FIXME" "$project_dir" --include="*.go" --include="*.py" --include="*.js" --include="*.ts" --include="*.java" 2>/dev/null | wc -l | tr -d ' ')
else
    todo_count=0
fi

# Format output with colors
# \e[36m cyan (user), \e[32m green (dir), \e[35m magenta (ctx), \e[33m yellow (time), \e[31m red (todo)
printf "\e[36m%s\e[0m:\e[32m%s\e[0m %s\e[35mctx:%d%%\e[0m %s \e[33m%s\e[0m \e[31mtodo:%s\e[0m" \
    "$user" "$dir" "$plan_indicator" "$ctx_used" "$model" "$time" "$todo_count"

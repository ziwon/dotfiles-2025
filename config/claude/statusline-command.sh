#!/usr/bin/env bash
input=$(cat)

user=$(whoami)
dir=$(echo "$input" | jq -r '.workspace.current_dir // .cwd')
short_dir=$(basename "$dir")

# Git branch (skip optional locks)
branch=$(git -C "$dir" symbolic-ref --short HEAD 2>/dev/null)

model=$(echo "$input" | jq -r '.model.display_name // empty')
remaining=$(echo "$input" | jq -r '.context_window.remaining_percentage // empty')

# Build prompt parts
parts=()

# user@dir
parts+=("$(printf '\033[32m%s\033[0m' "$user")$(printf '\033[37m@\033[0m')$(printf '\033[34m%s\033[0m' "$short_dir")")

# git branch
if [ -n "$branch" ]; then
  parts+=("$(printf '\033[33m(%s)\033[0m' "$branch")")
fi

# model
if [ -n "$model" ]; then
  parts+=("$(printf '\033[36m%s\033[0m' "$model")")
fi

# context remaining
if [ -n "$remaining" ]; then
  printf -v pct "%.0f" "$remaining"
  if [ "$pct" -le 20 ]; then
    color='\033[31m'
  elif [ "$pct" -le 50 ]; then
    color='\033[33m'
  else
    color='\033[32m'
  fi
  parts+=("$(printf "${color}ctx:%s%%\033[0m" "$pct")")
fi

printf '%s' "${parts[*]}"

# mise
eval "$(mise activate zsh)"

# mysql
export PATH="/opt/homebrew/opt/mysql@8.0/bin:$PATH"

# postgresql
export PATH="/opt/homebrew/opt/postgresql@16/bin:$PATH"

# 環境変数を別ファイルから読み込む
if [ -f ~/.private_env ]; then
  source ~/.private_env
fi

# エイリアスを設定
alias git-delete="~/scripts/git-delete-local-branches.sh"

claude-sandbox() {
  if [ ! -d "$HOME/.claude" ]; then
    echo "Error: ~/.claude not found. Please run 'claude' locally to complete setup first."
    return 1
  fi
  local oauth_token
  oauth_token="$(security find-generic-password -s 'Claude Code-credentials' -w 2>/dev/null | jq -r '.claudeAiOauth.accessToken')"
  local hash name
  hash=$(echo -n "$PWD" | shasum -a 256 | cut -c1-8)
  name="claude-${hash}"
  docker rm -f "$name" > /dev/null 2>&1
  docker create -it --name "$name" \
    -v "$PWD:$PWD" \
    -e CLAUDE_CODE_OAUTH_TOKEN="$oauth_token" \
    -w "$PWD" \
    docker/sandbox-templates:claude-code \
    /home/agent/.local/bin/claude --dangerously-skip-permissions --model claude-opus-4-6 "$@" > /dev/null
  docker cp "$HOME/.claude" "$name:/home/agent/.claude"
  if [ -f "$HOME/.claude.json" ]; then
    docker cp "$HOME/.claude.json" "$name:/home/agent/.claude.json"
  fi
  docker start -ai "$name"
  docker rm "$name" > /dev/null 2>&1
}
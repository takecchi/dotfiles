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
  local hash=$(echo -n "$PWD" | md5 -q | cut -c1-12)
  local name="claude-${hash}"
  if docker sandbox list 2>/dev/null | grep -q "$name"; then
    docker sandbox run "$name" -- --dangerously-skip-permissions "$@"
  else
    docker sandbox run --name "$name" claude -- --dangerously-skip-permissions "$@"
  fi
}
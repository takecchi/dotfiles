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
  if [ ! -f "$HOME/.claude.json" ]; then
    echo "Error: ~/.claude.json not found. Please run 'claude' locally to complete setup first."
    return 1
  fi
  # Keychainからcredentials(refresh token含む)を取得し、plaintext fallback用ファイルに書き出す
  # コンテナ内(Linux)のClaude Codeは ~/.claude/.credentials.json を読むため
  local credentials
  credentials="$(security find-generic-password -s 'Claude Code-credentials' -w 2>/dev/null)"
  if [ -z "$credentials" ]; then
    echo "Error: No credentials found in Keychain. Please run 'claude' locally to login first."
    return 1
  fi
  local cred_file="$HOME/.claude/.credentials.json"
  local cred_existed=false
  [ -f "$cred_file" ] && cred_existed=true
  echo "$credentials" > "$cred_file"
  chmod 600 "$cred_file"
  local hash name
  hash=$(echo -n "$PWD" | shasum -a 256 | cut -c1-8)
  name="claude-${hash}"
  docker rm -f "$name" > /dev/null 2>&1
  docker create -it --name "$name" \
    -v "$PWD:$PWD" \
    -v "$HOME/.claude:/home/agent/.claude" \
    -w "$PWD" \
    docker/sandbox-templates:claude-code \
    /home/agent/.local/bin/claude --dangerously-skip-permissions --model claude-opus-4-6 "$@" > /dev/null
  tar -cf - --no-xattrs --uid 1000 --gid 1000 -C "$HOME" .claude.json | docker cp - "$name:/home/agent/"
  docker start -ai "$name"
  docker rm "$name" > /dev/null 2>&1
  # ホスト側のcredentialsファイルをクリーンアップ(元々なかった場合のみ削除)
  if [ "$cred_existed" = false ]; then
    rm -f "$cred_file"
  fi
}
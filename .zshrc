# volta
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

# jenv
export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"

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
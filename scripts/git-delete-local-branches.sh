#!/bin/bash

# リポジトリ内であるかどうかを確認
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "このコマンドはGitリポジトリ内でのみ実行可能です。"
    exit 1
fi

# 現在のブランチを取得
current_branch=$(git symbolic-ref --short HEAD)

# ユーザーに確認を求める
echo "現在のブランチ[$current_branch]以外のローカルブランチをすべて削除します。"
echo "よろしいですか？ y/n"

# ユーザーの入力を読み取る
read answer

# ユーザーの入力が y または yes の場合、ブランチを削除
if [[ $answer =~ ^[Yy](es)?$ ]]; then
    # マージ済みブランチを除いて、現在のブランチ以外を削除
    git branch | grep -v "^\*" | grep -v "$current_branch" | xargs git branch -d
    echo "ブランチが削除されました。"
else
    echo "ブランチの削除をキャンセルしました。"
fi
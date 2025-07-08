#!/bin/bash

# リポジトリ内であるかどうかを確認
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "このコマンドはGitリポジトリ内でのみ実行可能なのだ。"
    exit 1
fi

# 現在のブランチを取得
current_branch=$(git symbolic-ref --short HEAD)

# 削除モード選択
echo "現在のブランチ[$current_branch]以外のローカルブランチを削除するのだ。"
echo "モードを選んで欲しいのだ！"
echo "  1) 通常削除 (-d): マージ済みブランチのみ削除"
echo "  2) 強制削除 (-D): マージされていなくても削除"
echo -n "番号を入力してください（1 or 2）: "
read mode

# 削除コマンド決定
if [[ "$mode" == "1" ]]; then
    delete_cmd="git branch -d"
elif [[ "$mode" == "2" ]]; then
    delete_cmd="git branch -D"
else
    echo "無効な入力なのだ！キャンセルするのだ。"
    exit 1
fi

# 実行確認
echo "本当に削除してもいいですか？ y/n"
read answer
if [[ $answer =~ ^[Yy](es)?$ ]]; then
    git branch | grep -v "^\*" | grep -v "$current_branch" | xargs -n 1 $delete_cmd
    echo "ブランチを削除したのだ〜！"
else
    echo "削除をキャンセルしたのだ。"
fi

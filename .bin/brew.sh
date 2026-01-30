#!/bin/zsh

# MacOSチェック
if [ "$(uname)" != "Darwin" ] ; then
  echo "Error: This script is not running on macOS."
  exit 1
fi

# .Brewfileからパッケージをインストール
brew bundle --global --verbose

# zshの設定を読み込む
source ~/.zshenv
source ~/.zprofile
source ~/.zshrc
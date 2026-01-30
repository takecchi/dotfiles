#!/bin/zsh

set -e

# MacOSチェック
if [ "$(uname)" != "Darwin" ] ; then
  echo "Error: This script is not running on macOS."
  exit 1
fi

# tapを先に追加（brew bundleで失敗することがあるため）
brew tap sqldef/sqldef

# .Brewfileからパッケージをインストール
brew bundle --global --verbose

# zshの設定を読み込む
source ~/.zshenv
source ~/.zprofile
source ~/.zshrc
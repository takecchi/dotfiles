#!/bin/zsh

set -e

# MacOSチェック
if [ "$(uname)" != "Darwin" ] ; then
  echo "Error: This script is not running on macOS."
  exit 1
fi

# tapを先に追加（brew bundleで失敗することがあるため）
brew tap sqldef/sqldef

# 非公式tapのformulaをbrew bundleで読み込めるようにtrustする
# （HOMEBREW_REQUIRE_TAP_TRUSTが有効な環境ではtrust必須。CIで失敗するため）
brew trust --tap sqldef/sqldef

# .Brewfileからパッケージをインストール
brew bundle --global --verbose

# zshの設定を読み込む
source ~/.zshenv
source ~/.zprofile
source ~/.zshrc
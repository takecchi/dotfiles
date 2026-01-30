#!/bin/zsh

set -e

# MacOSチェック
if [ "$(uname)" != "Darwin" ] ; then
  echo "Error: This script is not running on macOS."
  exit 1
fi

# Finder: 隠しファイル/フォルダを表示
defaults write com.apple.finder AppleShowAllFiles -bool true
# Finder: 拡張子を表示
defaults write -g AppleShowAllExtensions -bool true

# Finder: サイドバーにハードディスクを表示
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
defaults write com.apple.finder SidebarDevicesSectionDisclosedState -bool true

# Finderの設定を再起動して変更を適用
killall Finder &> /dev/null

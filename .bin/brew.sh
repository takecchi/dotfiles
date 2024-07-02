#!/bin/bash

# MacOSチェック
if [ "$(uname)" != "Darwin" ] ; then
  echo "Error: This script is not running on macOS."
  exit 1
fi

# .Brewfileからパッケージをインストール
brew bundle --global

# zshの設定を読み込む
source ~/.zshenv
source ~/.zprofile
source ~/.zshrc

# jenvの設定(corretto@21)
jenv add $(/usr/libexec/java_home -v 21)
jenv add $(brew --prefix openjdk@17)

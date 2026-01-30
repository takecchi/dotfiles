#!/bin/zsh

# MacOSチェック
if [ "$(uname)" != "Darwin" ] ; then
  echo "Error: This script is not running on macOS."
  exit 1
fi

# Xcode Command Line Toolsのインストール
if ! xcode-select -p &>/dev/null; then
    echo "Installing Xcode Command Line Tools..."
    xcode-select --install
    # インストールが完了するのを待つ
    until xcode-select -p &>/dev/null; do
        sleep 5
    done
else
    echo "Xcode Command Line Tools are already installed."
fi

# Homebrewがインストールされていなければインストールする
if ! command -v brew >/dev/null 2>&1; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "Homebrew is already installed."
fi
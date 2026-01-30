#!/bin/zsh

set -e

echo "=========================================="
echo "Preparing for mise migration"
echo "=========================================="
echo ""

# MacOSチェック
if [ "$(uname)" != "Darwin" ] ; then
  echo "Error: This script is not running on macOS."
  exit 1
fi

echo "Step 1: Uninstalling old Homebrew packages..."
echo "-------------------------------------------"

# 管理ツールをアンインストール
if brew list volta &> /dev/null; then
  echo "Uninstalling volta..."
  brew uninstall volta
else
  echo "volta is not installed, skipping."
fi

if brew list pyenv &> /dev/null; then
  echo "Uninstalling pyenv..."
  brew uninstall pyenv
else
  echo "pyenv is not installed, skipping."
fi

if brew list jenv &> /dev/null; then
  echo "Uninstalling jenv..."
  brew uninstall jenv
else
  echo "jenv is not installed, skipping."
fi

if brew list go &> /dev/null; then
  echo "Uninstalling go..."
  brew uninstall go
else
  echo "go is not installed, skipping."
fi

if brew list openjdk@17 &> /dev/null; then
  echo "Uninstalling openjdk@17..."
  brew uninstall openjdk@17
else
  echo "openjdk@17 is not installed, skipping."
fi

if brew list --cask corretto@21 &> /dev/null; then
  echo "Uninstalling corretto@21..."
  brew uninstall --cask corretto@21
else
  echo "corretto@21 is not installed, skipping."
fi

if brew list gradle &> /dev/null; then
  echo "Uninstalling gradle..."
  brew uninstall gradle
else
  echo "gradle is not installed, skipping."
fi

echo ""
echo "Step 2: Cleaning up old configuration directories..."
echo "-------------------------------------------"

# 古い設定ディレクトリを削除
if [ -d ~/.volta ]; then
  echo "Removing ~/.volta..."
  rm -rf ~/.volta
fi

if [ -d ~/.pyenv ]; then
  echo "Removing ~/.pyenv..."
  rm -rf ~/.pyenv
fi

if [ -d ~/.jenv ]; then
  echo "Removing ~/.jenv..."
  rm -rf ~/.jenv
fi

echo ""
echo "=========================================="
echo "Preparation completed!"
echo "=========================================="
echo ""

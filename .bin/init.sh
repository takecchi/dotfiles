#!/bin/zsh

set -e

# MacOSチェック
if [ "$(uname)" != "Darwin" ] ; then
  echo "Error: This script is not running on macOS."
  exit 1
fi

# Xcode Command Line Toolsのインストール
if ! xcode-select -p &>/dev/null; then
    echo "Installing Xcode Command Line Tools..."
    xcode-select --install
    echo "Please complete the installation dialog, then press Enter to continue..."
    read
else
    echo "Xcode Command Line Tools are already installed."
fi

# Homebrewがインストールされていなければインストールする
if ! command -v brew >/dev/null 2>&1; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    # インストール直後にPATHを通す
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    echo "Homebrew is already installed."
fi

# Claude CLI がインストールされていなければインストール
if ! command -v claude >/dev/null 2>&1; then
    echo "Installing Claude CLI..."

    curl -fsSL https://claude.ai/install.sh | bash

    # 一般的なインストール先
    CLAUDE_BIN="$HOME/.local/bin"

    if [ -f "$CLAUDE_BIN/claude" ]; then
        echo "Claude installed at $CLAUDE_BIN/claude"

        # 現在のシェルにPATH追加
        export PATH="$CLAUDE_BIN:$PATH"
    else
        echo "Claude installation failed or binary not found."
        exit 1
    fi
else
    echo "Claude CLI is already installed."
fi

# Grok CLI がインストールされていなければインストール
GROK_BIN="$HOME/.grok/bin"

# 過去のインストールが残した壊れたシンボリックリンクを掃除
for link in "$HOME/.local/bin/grok" "$HOME/.local/bin/agent"; do
    if [ -L "$link" ] && [ ! -e "$link" ]; then
        echo "Removing broken symlink: $link"
        rm -f "$link"
    fi
done

if [ -x "$GROK_BIN/grok" ]; then
    echo "Grok CLI is already installed."
else
    echo "Installing Grok CLI..."

    # 先にPATHへ追加しておくことで、インストーラが~/.local/binへ
    # シンボリックリンクを作るのを抑止する
    export PATH="$GROK_BIN:$PATH"

    # SHELL=/bin/sh を指定してインストーラによるシェル設定ファイルの
    # 書き換えを回避する（~/.zshrcはdotfilesのシンボリックリンクのため）
    curl -fsSL https://x.ai/cli/install.sh | SHELL=/bin/sh bash

    if [ -x "$GROK_BIN/grok" ]; then
        echo "Grok installed at $GROK_BIN/grok"
    else
        echo "Grok installation failed or binary not found."
        exit 1
    fi
fi

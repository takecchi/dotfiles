# dotfiles
.files for macOS

以下の設定・インストールを行います。

- Homebrewのインストール
- Xcodeのインストール
- dotfilesのシンボリックリンクの作成
- ファイルの拡張子が表示されるようにする
- Homebrewでのパッケージのインストール
- `~/.private_env`の作成
- ⚠ gitconfigの設定が自分用(takecchi)になっています。

## Installation
```bash
cd ~
git clone git@github.com:takecchi/dotfiles.git
cd dotfiles
make
```

## miseによるランタイム管理
[mise](https://mise.jdx.dev/)を使用して以下のランタイムをインストール・管理できます。

- Go
- Java
- Gradle
- Python
- Node.js

```bash
# 例: Node.js のインストール
mise use node@22

# 例: Python のインストール
mise use python@3.12

# インストール済みのランタイム確認
mise list
```

## 非公開の環境変数について
`.zshrc`から`~/.private_env`を読み込むようにしています。    
非公開の環境変数は`~/.private_env`に記述することで管理が可能です。

例: `~/.private_env`
```bash
export GITHUB_TOKEN=xxxxxxxxxxxxxxx
```
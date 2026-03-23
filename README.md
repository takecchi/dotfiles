# dotfiles
.files for macOS

以下の設定・インストールを行います。

- Homebrewのインストール
- Xcodeのインストール
- dotfilesのシンボリックリンクの作成
- ファイルの拡張子が表示されるようにする
- Homebrewでのパッケージのインストール
- `~/.private_env`の作成
- `.gitconfig`の対話セットアップ（ユーザー名・メール・SSH署名）

## Installation
```bash
cd ~
git clone git@github.com:takecchi/dotfiles.git
cd dotfiles
make
```

## Git設定の対話セットアップ

`~/.gitconfig` が存在しない場合、初回実行時に対話形式で設定します。

```
Git configuration setup
Enter your Git user name: Your Name
Enter your Git email: you@example.com
Enable SSH commit signing? (y/n): y
```

SSH署名を有効にすると、以下の流れで鍵を設定します。

1. `~/.ssh/id_*.pub` から既存の公開鍵を自動検出
2. 一覧から使用する鍵を選択、または `0` で新規生成
3. 新規生成時は `ssh-keygen` で ed25519 鍵を作成し、GitHub登録用のURLを案内

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
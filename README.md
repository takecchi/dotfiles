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

## 非公開の環境変数について
`.zshrc`から`~/.private_env`を読み込むようにしています。    
非公開の環境変数は`~/.private_env`に記述することで管理が可能です。

例: `~/.private_env`
```bash
export GITHUB_TOKEN=xxxxxxxxxxxxxxx
```
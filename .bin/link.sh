#!/bin/zsh

# スクリプトの実際の場所を取得
SCRIPT_DIR="${0:A:h}"
DOTFILES_DIR="${SCRIPT_DIR:h}"

# dotfilesディレクトリ内の各ファイルとディレクトリに対して処理
for dotfile in "${DOTFILES_DIR}"/{.,}*; do
  # ファイル名のみを抽出
  filename=$(basename "${dotfile}")

  # 特定のファイルやディレクトリはスキップ
  [[ "${filename}" == "." ]] && continue
  [[ "${filename}" == ".." ]] && continue
  [[ "${filename}" == "README.md" ]] && continue
  [[ "${filename}" == ".git" ]] && continue
  [[ "${filename}" == ".github" ]] && continue
  [[ "${filename}" == ".DS_Store" ]] && continue
  [[ "${filename}" == ".idea" ]] && continue
  [[ "${filename}" == "Makefile" ]] && continue

  # ターゲットとなるパス
  target="${HOME}/${filename}"

  # 既に存在するファイルやディレクトリはスキップ
  if [ ! -e "${target}" ]; then
    echo "Linking ${dotfile} to ${target}"
    ln -s "${dotfile}" "$target"
  else
    echo "${target} already exists, skipping."
  fi
done

# .private_envが存在しなければ作成
if [ ! -f ${HOME}/.private_env ]; then
  echo "# 非公開の環境変数を管理" > "${HOME}/.private_env"
fi
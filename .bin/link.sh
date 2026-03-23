#!/bin/zsh

set -e

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
if [ ! -f "${HOME}/.private_env" ]; then
  echo "# 非公開の環境変数を管理" > "${HOME}/.private_env"
fi

# .gitconfigが存在しなければテンプレートから生成
if [ ! -f "${HOME}/.gitconfig" ]; then
  printf '\033[0;33mGit configuration setup\033[0m\n'

  # ユーザー名の入力
  printf "Enter your Git user name: "
  read -r GIT_USER_NAME
  [[ -z "${GIT_USER_NAME}" ]] && { echo "Name cannot be empty." >&2; exit 1; }

  # メールアドレスの入力
  printf "Enter your Git email: "
  read -r GIT_USER_EMAIL
  [[ -z "${GIT_USER_EMAIL}" ]] && { echo "Email cannot be empty." >&2; exit 1; }

  # git configコマンドで安全に値を書き込む
  git config --file "${HOME}/.gitconfig" user.name "${GIT_USER_NAME}"
  git config --file "${HOME}/.gitconfig" user.email "${GIT_USER_EMAIL}"
  git config --file "${HOME}/.gitconfig" core.autocrlf input

  # SSH署名の設定
  printf "Enable SSH commit signing? (y/n): "
  read -r ENABLE_SIGNING

  if [[ "${ENABLE_SIGNING}" =~ ^[Yy]$ ]]; then
    SSH_SIGNING_KEY=""

    # 既存のSSH公開鍵を探す
    SSH_PUBKEYS=()
    for keyfile in "${HOME}"/.ssh/id_*.pub; do
      [[ -f "${keyfile}" ]] && SSH_PUBKEYS+=("${keyfile}")
    done

    if (( ${#SSH_PUBKEYS[@]} > 0 )); then
      printf '\n既存のSSH公開鍵が見つかりました:\n'
      for i in {1..${#SSH_PUBKEYS[@]}}; do
        printf "  %d) %s\n" "${i}" "${SSH_PUBKEYS[$i]}"
        printf "     %s\n" "$(cat "${SSH_PUBKEYS[$i]}")"
      done

      printf '\n使用する鍵の番号を選択してください (0 = 新しく生成する): '
      read -r KEY_CHOICE

      if [[ "${KEY_CHOICE}" =~ ^[1-9][0-9]*$ ]] && (( KEY_CHOICE <= ${#SSH_PUBKEYS[@]} )); then
        SSH_SIGNING_KEY="$(cat "${SSH_PUBKEYS[$KEY_CHOICE]}")"
      fi
    fi

    # 鍵が選択されなかった場合は新規生成
    if [[ -z "${SSH_SIGNING_KEY}" ]]; then
      printf '\n新しいSSH鍵を生成します。\n'
      SSH_KEY_PATH="${HOME}/.ssh/id_ed25519"

      # 既存の鍵と被らないパスを決定
      if [[ -f "${SSH_KEY_PATH}" ]]; then
        SSH_KEY_PATH="${HOME}/.ssh/id_ed25519_signing"
        printf '  id_ed25519 は既に存在するため %s に生成します。\n' "${SSH_KEY_PATH}"
      fi

      ssh-keygen -t ed25519 -C "${GIT_USER_EMAIL}" -f "${SSH_KEY_PATH}"
      SSH_SIGNING_KEY="$(cat "${SSH_KEY_PATH}.pub")"

      printf '\n\033[0;33m以下の公開鍵をGitHubに登録してください (Settings > SSH and GPG keys > New SSH Key、Key type: Signing Key):\033[0m\n'
      printf '  %s\n' "${SSH_SIGNING_KEY}"
      printf '  https://github.com/settings/ssh/new\n\n'
    fi

    git config --file "${HOME}/.gitconfig" commit.gpgsign true
    git config --file "${HOME}/.gitconfig" gpg.format ssh
    git config --file "${HOME}/.gitconfig" user.signingkey "${SSH_SIGNING_KEY}"
    printf '\033[0;32mSSH commit signing enabled.\033[0m\n'
  fi

  printf '\033[0;32m.gitconfig created successfully.\033[0m\n'
fi
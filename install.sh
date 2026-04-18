#!/bin/bash
# shot skill installer
# Claude Code / Gemini CLI / Codex 対応
# 使い方: bash install.sh [--claude | --gemini | --codex | --all]

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_NAME="shot"

# ──────────────────────────────────────────
# インストール対象の選択
# ──────────────────────────────────────────
ARG="${1:-}"

if [ "$ARG" = "--claude" ]; then
    INSTALL_CLAUDE=true; INSTALL_GEMINI=false; INSTALL_CODEX=false
elif [ "$ARG" = "--gemini" ]; then
    INSTALL_CLAUDE=false; INSTALL_GEMINI=true;  INSTALL_CODEX=false
elif [ "$ARG" = "--codex" ]; then
    INSTALL_CLAUDE=false; INSTALL_GEMINI=false; INSTALL_CODEX=true
elif [ "$ARG" = "--all" ]; then
    INSTALL_CLAUDE=true; INSTALL_GEMINI=true; INSTALL_CODEX=true
else
    echo "=== shot スキル インストーラー ==="
    echo ""
    echo "インストール対象を選択してください:"
    echo "  1) Claude Code"
    echo "  2) Gemini CLI"
    echo "  3) Codex"
    echo "  4) すべて"
    read -rp "選択 [1-4]: " CHOICE
    case "$CHOICE" in
        1) INSTALL_CLAUDE=true;  INSTALL_GEMINI=false; INSTALL_CODEX=false ;;
        2) INSTALL_CLAUDE=false; INSTALL_GEMINI=true;  INSTALL_CODEX=false ;;
        3) INSTALL_CLAUDE=false; INSTALL_GEMINI=false; INSTALL_CODEX=true  ;;
        4) INSTALL_CLAUDE=true;  INSTALL_GEMINI=true;  INSTALL_CODEX=true  ;;
        *) echo "無効な選択です。終了します。"; exit 1 ;;
    esac
fi

echo ""
echo "=== shot スキル インストーラー ==="
echo ""

# ──────────────────────────────────────────
# ~/Screenshots ディレクトリの確認・作成
# ──────────────────────────────────────────
if [ ! -d "$HOME/Screenshots" ]; then
    mkdir -p "$HOME/Screenshots"
    echo "[OK] ~/Screenshots ディレクトリを作成しました"
    echo "     Mac側のスクリーンショット同期先をこのディレクトリに設定してください。"
    echo "     設定方法: docs/mac-sync-setup.md を参照"
    echo ""
fi

# ──────────────────────────────────────────
# 共通: シンボリックリンク作成ヘルパー
# ──────────────────────────────────────────
install_symlink() {
    local TARGET_DIR="$1"
    local LINK_PATH="$TARGET_DIR/$SKILL_NAME"

    mkdir -p "$TARGET_DIR"

    if [ -L "$LINK_PATH" ]; then
        echo "[SKIP] 既にシンボリックリンクが存在します: $LINK_PATH -> $(readlink "$LINK_PATH")"
        return 0
    fi

    if [ -d "$LINK_PATH" ]; then
        local BAK_PATH="${LINK_PATH}.bak"
        echo "[WARNING] 既存のスキルディレクトリが見つかりました: $LINK_PATH"
        read -rp "  バックアップして置き換えますか？ [y/N]: " CONFIRM
        if [[ "$CONFIRM" =~ ^[Yy]$ ]]; then
            mv "$LINK_PATH" "$BAK_PATH"
            echo "[OK] バックアップ: $BAK_PATH"
        else
            echo "[SKIP] インストールをスキップしました"
            return 0
        fi
    fi

    ln -s "$SCRIPT_DIR" "$LINK_PATH"
    echo "[OK] シンボリックリンクを作成: $LINK_PATH -> $SCRIPT_DIR"
}

# ──────────────────────────────────────────
# Claude Code インストール
# ──────────────────────────────────────────
install_claude() {
    echo "--- Claude Code ---"
    install_symlink "$HOME/.claude/skills"
    echo ""
    echo "[完了] Claude Code への shot インストール完了"
    echo "  使い方: /shot [指示]"
    echo "  例: /shot このエラーを説明して"
}

# ──────────────────────────────────────────
# Gemini CLI インストール
# ──────────────────────────────────────────
install_gemini() {
    echo "--- Gemini CLI ---"

    if ! command -v gemini &>/dev/null; then
        echo "[WARNING] gemini コマンドが見つかりません。Gemini CLI をインストールしてから再実行してください。"
        echo "  https://github.com/google-gemini/gemini-cli"
        return 0
    fi

    gemini skills link "$SCRIPT_DIR" --consent
    echo "[OK] gemini skills link 完了"
    echo ""
    echo "[完了] Gemini CLI への shot インストール完了"
    echo "  使い方: /shot [指示]"
}

# ──────────────────────────────────────────
# Codex インストール
# ──────────────────────────────────────────
install_codex() {
    echo "--- Codex ---"
    install_symlink "$HOME/.codex/skills"
    echo ""
    echo "[完了] Codex への shot インストール完了"
    echo "  使い方: /shot [指示]"
}

# ──────────────────────────────────────────
# 実行
# ──────────────────────────────────────────
if [ "$INSTALL_CLAUDE" = true ]; then
    install_claude
    echo ""
fi

if [ "$INSTALL_GEMINI" = true ]; then
    install_gemini
    echo ""
fi

if [ "$INSTALL_CODEX" = true ]; then
    install_codex
    echo ""
fi

echo "=== インストール完了 ==="
echo ""
echo "アップデート方法:"
echo "  cd $SCRIPT_DIR && git pull"
echo "  (シンボリックリンク経由で全CLIに即時反映されます)"

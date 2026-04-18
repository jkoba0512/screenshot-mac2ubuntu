#!/bin/bash
# shot skill uninstaller
# 使い方: bash uninstall.sh [--claude | --gemini | --codex | --all]

set -euo pipefail

SKILL_NAME="shot"

ARG="${1:-}"

if [ "$ARG" = "--claude" ]; then
    UNINSTALL_CLAUDE=true; UNINSTALL_GEMINI=false; UNINSTALL_CODEX=false
elif [ "$ARG" = "--gemini" ]; then
    UNINSTALL_CLAUDE=false; UNINSTALL_GEMINI=true;  UNINSTALL_CODEX=false
elif [ "$ARG" = "--codex" ]; then
    UNINSTALL_CLAUDE=false; UNINSTALL_GEMINI=false; UNINSTALL_CODEX=true
elif [ "$ARG" = "--all" ]; then
    UNINSTALL_CLAUDE=true; UNINSTALL_GEMINI=true; UNINSTALL_CODEX=true
else
    echo "=== shot スキル アンインストーラー ==="
    echo ""
    echo "アンインストール対象を選択してください:"
    echo "  1) Claude Code"
    echo "  2) Gemini CLI"
    echo "  3) Codex"
    echo "  4) すべて"
    read -rp "選択 [1-4]: " CHOICE
    case "$CHOICE" in
        1) UNINSTALL_CLAUDE=true;  UNINSTALL_GEMINI=false; UNINSTALL_CODEX=false ;;
        2) UNINSTALL_CLAUDE=false; UNINSTALL_GEMINI=true;  UNINSTALL_CODEX=false ;;
        3) UNINSTALL_CLAUDE=false; UNINSTALL_GEMINI=false; UNINSTALL_CODEX=true  ;;
        4) UNINSTALL_CLAUDE=true;  UNINSTALL_GEMINI=true;  UNINSTALL_CODEX=true  ;;
        *) echo "無効な選択です。終了します。"; exit 1 ;;
    esac
fi

echo ""
echo "=== shot スキル アンインストーラー ==="
echo ""

remove_symlink() {
    local LINK_PATH="$1"
    local BAK_PATH="${LINK_PATH}.bak"

    if [ -L "$LINK_PATH" ]; then
        rm "$LINK_PATH"
        echo "[OK] シンボリックリンクを削除: $LINK_PATH"

        if [ -d "$BAK_PATH" ]; then
            read -rp "  バックアップ ($BAK_PATH) を復元しますか？ [y/N]: " CONFIRM
            if [[ "$CONFIRM" =~ ^[Yy]$ ]]; then
                mv "$BAK_PATH" "$LINK_PATH"
                echo "[OK] バックアップを復元しました: $LINK_PATH"
            fi
        fi
    elif [ -d "$LINK_PATH" ]; then
        echo "[WARNING] $LINK_PATH はシンボリックリンクではありません。手動で削除してください。"
    else
        echo "[SKIP] $LINK_PATH が見つかりません"
    fi
}

if [ "$UNINSTALL_CLAUDE" = true ]; then
    echo "--- Claude Code ---"
    remove_symlink "$HOME/.claude/skills/$SKILL_NAME"
    echo ""
fi

if [ "$UNINSTALL_GEMINI" = true ]; then
    echo "--- Gemini CLI ---"
    if command -v gemini &>/dev/null; then
        gemini skills uninstall "$SKILL_NAME" 2>/dev/null && echo "[OK] gemini skills uninstall 完了" || echo "[SKIP] Gemini スキルが見つかりません"
    else
        echo "[SKIP] gemini コマンドが見つかりません"
    fi
    echo ""
fi

if [ "$UNINSTALL_CODEX" = true ]; then
    echo "--- Codex ---"
    remove_symlink "$HOME/.codex/skills/$SKILL_NAME"
    echo ""
fi

echo "=== アンインストール完了 ==="

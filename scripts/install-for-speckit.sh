#!/bin/bash
# =============================================================================
# install-for-speckit.sh
#
# spec-kit プロジェクトに Web Starter Kit の規約群を導入するインストーラー。
#
# 使い方:
#   cd /path/to/your-speckit-project
#   curl -sL https://raw.githubusercontent.com/murakami-shoten/web-starter-kit/main/scripts/install-for-speckit.sh | bash
#
# 前提:
#   - spec-kit が初期化済みのプロジェクト（.specify/ が存在する）
#   - Git が利用可能
#
# 処理内容:
#   1. spec-kit プロジェクトかどうか確認
#   2. docs/governance/ に Web Starter Kit をサブモジュール追加
#   3. constitution 生成用プロンプトファイルを配置
# =============================================================================
set -euo pipefail

# --- 設定 ---
REPO_URL="https://github.com/murakami-shoten/web-starter-kit.git"
INSTALL_PATH="docs/governance"
PROMPT_FILE=".specify/memory/constitution-prompt.md"

# --- 色定義 ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# --- ヘルパー関数 ---
info()  { echo -e "${GREEN}✅ $1${NC}"; }
warn()  { echo -e "${YELLOW}⚠️  $1${NC}"; }
error() { echo -e "${RED}❌ $1${NC}"; exit 1; }

# =============================================================================
# Step 1: 事前チェック
# =============================================================================
echo ""
echo "🔧 Web Starter Kit 規約 → spec-kit 連携インストーラー"
echo "======================================================="
echo ""

# spec-kit プロジェクトかどうか確認
if [ ! -d ".specify" ]; then
  error ".specify/ ディレクトリが見つかりません。spec-kit プロジェクトのルートで実行してください。"
fi

# Git リポジトリかどうか確認
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
  error "Git リポジトリではありません。git init を先に実行してください。"
fi

# =============================================================================
# Step 2: 規約をサブモジュールとして追加
# =============================================================================
if [ -d "$INSTALL_PATH" ]; then
  warn "$INSTALL_PATH は既に存在します。サブモジュールの追加をスキップします。"
else
  echo "📥 Web Starter Kit の規約群をダウンロード中..."
  git submodule add "$REPO_URL" "$INSTALL_PATH"
  info "規約を $INSTALL_PATH に配置しました。"
fi

# =============================================================================
# Step 3: Constitution 生成用プロンプトを配置
# =============================================================================
if [ -f "$PROMPT_FILE" ]; then
  warn "$PROMPT_FILE は既に存在します。上書きしません。"
else
  echo "📝 Constitution 生成用プロンプトを配置中..."
  cat > "$PROMPT_FILE" << 'PROMPT_EOF'
# Constitution 生成プロンプト

このファイルは `/speckit.constitution` コマンドに入力するためのプロンプトです。
AI エージェント上で以下のプロンプトをコピーして実行してください。

---

docs/governance/ に配置された Web Starter Kit の規約群に基づいて、
このプロジェクトの Constitution を作成してください。

## Core Principles として以下の規約を読み込み、統合すること:

1. **開発規約**: docs/governance/docs/rules/DEV_RULES.md
   - コミット規約、ブランチ戦略、コードスタイル等
2. **アーキテクチャ**: docs/governance/docs/rules/ARCHITECTURE_RULES.md
   - 疎結合、レイヤー構成、依存方向の原則
3. **セキュリティ**: docs/governance/docs/rules/SECURITY_RULES.md
   - CSP、HSTS、入力検証、認証の必須要件
4. **品質ゲート**: docs/governance/docs/rules/QUALITY_GATES.md
   - lint / typecheck / test / build / secret scan / vuln scan の必須7項目

## 追加セクションとして:

- **UI/UX 設計**: docs/governance/docs/rules/DESIGN_RULES.md
  （ISO 9241 / Nielsen ヒューリスティクスに基づく設計原則）
- **SEO**: docs/governance/docs/rules/SEO_RULES.md
  （Google 推奨準拠の技術要件）
- **パフォーマンス**: docs/governance/docs/rules/PERFORMANCE_RULES.md
  （CWV / フォント最適化 / 画像最適化）
- **リリースプロセス**: docs/governance/docs/runbooks/RELEASE_CHECKLIST.md

## 要件定義テンプレート参照:

仕様策定時は docs/governance/docs/requirements/ 配下のテンプレートを使用すること:
- ヒアリングシート: HEARING_SHEET.md
- 要件定義書テンプレート: REQUIREMENTS_TEMPLATE.md
- SOW テンプレート: SOW_TEMPLATE.md
- 機能仕様書テンプレート: FEATURE_SPEC_TEMPLATE.md（複雑な機能のみ）

## Governance:

- Constitution は docs/governance/ の規約群を反映する
- 規約を変更する場合は、元ファイルを更新し、Constitution を再生成する
- すべての実装前に Constitution Check を通過すること

PROMPT_EOF
  info "Constitution 生成用プロンプトを $PROMPT_FILE に配置しました。"
fi

# =============================================================================
# 完了メッセージ
# =============================================================================
echo ""
echo "======================================================="
info "インストールが完了しました！"
echo ""
echo "📋 次のステップ:"
echo ""
echo "  1. AI エージェント（Claude Code 等）を起動"
echo "  2. /speckit.constitution コマンドを実行"
echo "  3. $PROMPT_FILE の内容をプロンプトとして入力"
echo "  4. 生成された .specify/memory/constitution.md を確認"
echo "  5. git add . && git commit -m 'feat: integrate web-governance rules'"
echo ""
echo "📖 詳細: https://github.com/murakami-shoten/web-starter-kit#spec-kit-との連携"
echo "======================================================="

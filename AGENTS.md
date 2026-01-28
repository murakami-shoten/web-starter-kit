# AGENTS.md（一次ソース / AIエージェント共通ガイド）

このリポジトリは「あらゆるWebサイト構築」を素早く始め、他プロジェクトへも流用できる完璧なベースプロジェクトを提供する土台です。
SEO・セキュリティ・可搬性・拡張性・低ロックイン・テスト/品質ゲートを、**国際標準 / Google推奨 / 定石 / ベストプラクティス**を基準に担保します。

---

## 0. 重要：このリポジトリでの作業順序（必須）

**実装を始める前に、必ず要件定義を完了してください。推測で実装しないこと。**

1) `docs/requirements/HEARING_SHEET.md` を確認し、未記入項目を抽出  
2) 未記入項目は**ユーザーに質問**して回答を得る（推測禁止）  
3) まず `docs/requirements/REQUIREMENTS_TEMPLATE.md` を複製し、`docs/requirements/projects/<project_slug>/REQUIREMENTS_<project_slug>.md` を作成する（テンプレは編集しない）
4) 回答を新規作成した要件定義書に反映（TBDはTBDのまま明示）  
5) 要件の矛盾/未確定/リスク（SEO/法務/アクセシビリティ/セキュリティ/運用）を列挙して合意を取る  
6) 要件が合意できたら、フェーズごとにSOWを作成し合意する（テンプレ: `docs/requirements/SOW_TEMPLATE.md`、保存先: `docs/requirements/projects/<project_slug>/SOW_<phase>.md`）  
7) `docs/rules/QUALITY_GATES.md` のゲートに沿ってタスク分解し、実装開始

---

## 1. 参照すべき規約（この順で読む）

- 開発規約: `docs/rules/DEV_RULES.md`
- アーキテクチャ/低ロックイン方針: `docs/rules/ARCHITECTURE_RULES.md`, `docs/rules/LOW_LOCKIN_RULES.md`
- SEO規約（Google推奨準拠）: `docs/rules/SEO_RULES.md`
- セキュリティ規約（CSP/ヘッダー/ASVS）: `docs/rules/SECURITY_RULES.md`
- 可観測性・ログ方針: `docs/rules/OBSERVABILITY_RULES.md`
- コンテンツ可搬性（MDX/運用）: `docs/rules/CONTENT_RULES.md`
- 品質ゲート（テスト/脆弱性/性能/a11y）: `docs/rules/QUALITY_GATES.md`
- リリース運用: `docs/runbooks/RELEASE_CHECKLIST.md`

---

## 2. 不変条件（破ってはいけない）

### 2.1 運用 / 環境
- 環境は環境変数で切替（dev/staging/production）
- 基本方針：ブランチ運用で環境別デプロイ（例）
  - `main` → production
  - `staging` → staging
  - `dev` → dev（検証/共有）
- 秘密情報（鍵・APIキー等）はGitに入れない。コミット前提で検出も行う。

### 2.2 開発環境（Docker前提）
- **ホストに npm / node が無くても動く**こと（Dockerのみで起動可能）
- 初期ポート番号は他プロジェクトと衝突しにくい値を採用し、設定で変更可能にする

### 2.3 SEO / セキュリティ
- SEOはGoogle推奨と整合し、技術要件（サイトマップ/メタ/構造化データ等）を標準実装する
- セキュリティはCSP/セキュリティヘッダーを標準装備し、脆弱性チェックをCI相当に必須化する（詳細は各規約）

---

## 3. AIエージェントへの作業ルール（共通）

- 変更は最小単位で、意図と理由を説明する（なぜ必要か）
- **ユーザーとの対話・質問・Artifact作成は、原則として日本語で行うこと**
- **要件定義などのヒアリングを行う際は、一度に全ての質問をせず、対話的に（一問一答または少数ずつ）進めること**

- 既存設計（疎結合・低ロックイン）に反する提案をする場合は、**代替案**と**移行コスト**も提示する
- 実装前に `docs/requirements/REQUIREMENTS.md` に立ち戻り、要件と一致しているか確認する
- セキュリティ関連（CSP/認証/権限/入力）を変更する場合は、必ず `docs/rules/SECURITY_RULES.md` のチェック項目に照らす
- **禁止事項**: 投げやり・他責・サボタージュ・虚偽報告は厳禁（進捗/問題は正直に報告する）

---

## 4. 実装開始の合図（Definition of Ready）
以下が揃ってから実装を開始すること:

- `docs/requirements/HEARING_SHEET.md` が埋まっている（TBD含む）
- `docs/requirements/projects/<project_slug>/REQUIREMENTS_<project_slug>.md` が作成/更新されている（テンプレではない）
- 未確定事項（TBD）とリスクが列挙され、対応方針が決まっている
- 対象フェーズのSOW（テンプレ: `docs/requirements/SOW_TEMPLATE.md` → 保存: `docs/requirements/projects/<project_slug>/SOW_<phase>.md`）にスコープ/成果物/受入基準が明記され、合意できている
- `docs/rules/QUALITY_GATES.md` のゲートを満たす見通しが立っている

---

（作成日: 2026-01-27 JST）

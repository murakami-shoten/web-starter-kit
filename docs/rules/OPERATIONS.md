# 運用方針（OPERATIONS）

（作成日: 2026-01-27 JST）

---

## 1. 環境とデプロイ

- 環境変数で dev/staging/prod を切替
- ブランチ運用で環境にデプロイ（main=prod, staging=staging, dev=dev のように整理）

---

## 2. ログ確認

- ローカル: コンソール
- staging/prod: デプロイ先管理画面のログ（必要なら外部ログ基盤へ）

---

## 3. 変更管理

- 変更はPR単位で、品質ゲートを通してからマージ
- 重大変更はリリースチェックリストを必ず通す
- ソースコードレベルでのルール適合チェック（RELEASE_CHECKLIST 参照）を実施する

---

## 4. 保守・セキュリティパッチ適用

### 4.1 定期更新（依存パッケージ）
- **頻度**: 最低でも月次で確認
- **方針**: `DEV_RULES` に従い、原則として最新安定版（Stable）へアップデートする
- **確認**: 更新後は `QUALITY_GATES` の必須テスト（test/build/lint）を通過させること

**自動化（推奨）:**
- Renovate または Dependabot を導入し、依存更新の PR を自動生成する
- 導入するかは `HEARING_SHEET.md` §10 でプロジェクトごとに合意する
- 推奨設定方針:
  - patch / minor は自動マージ（テスト全通過時）
  - major は手動レビュー必須
  - 関連パッケージはグルーピング（例: eslint 関連をまとめて1PR）
  - セキュリティアップデートは優先度を上げて即時 PR 作成

### 4.2 緊急セキュリティパッチ
- **検知**: GitHub Security Alerts / Snyk / OSV-Scanner 等でCritical/Highの脆弱性を検知した場合
- **対応**: 
    1. 影響範囲を調査（実際にその機能を使っているか）
    2. 修正パッチが提供され次第、速やかに適用してリリース（原則24時間以内を目標）
    3. 修正版がない場合は、WAF等での緩和策または機能停止を検討する
- **例外**: 互換性等でどうしても上げられない場合は、リスク受容の承認を得てIssueに期限付きで記録する

### 4.3 自動リリース（プロジェクト判断）

Conventional Commits（`DEV_RULES.md` §3.1）に基づき、CHANGELOG やバージョン管理を自動化できる。導入するかは `HEARING_SHEET.md` §10 で合意する。

| ツール | 特徴 |
|---|---|
| [semantic-release](https://github.com/semantic-release/semantic-release) | CI 連動で完全自動（npm publish / GitHub Release / CHANGELOG 生成） |
| [standard-version](https://github.com/conventional-changelog/standard-version) | ローカル実行型（CHANGELOG 生成 + バージョンバンプ） |

- **導入推奨ケース**: チーム開発でリリース頻度が高い場合
- **不要なケース**: 個人開発・リリース頻度が低い場合（手動管理で十分）


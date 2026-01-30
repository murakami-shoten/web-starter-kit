# Web Starter Kit

このリポジトリは「あらゆるWebサイト構築」を素早く始められるテンプレート兼ベースプロジェクトです。要件定義から実装・テスト・保守計画までを一貫して進められる規範的なドキュメント群を備え、AIを活用した開発も、AIを使わないチーム開発も同じ手順で運用できます。

## 特徴
- 要件定義ファースト: ヒアリングシート→要件定義書→リスク明示の流れを標準化。
- Next.js（App Router）+ TypeScript を前提とした設計指針を提供（コードはこれから追加する想定）。
- SEO / セキュリティ / 可搬性 / 低ロックイン / 拡張性を国際標準・Google推奨・定石に沿って担保する規約付き。
- Docker 前提で、ホストに Node/npm が無くても開発・CI を再現可能な方針。
- AIエージェント利用時の運用ルールを明文化（日本語での逐次ヒアリング、一問一答）。

## リポジトリ構成
- `AGENTS.md`: AIエージェント共通ガイド（一次ソース）。作業順序と不変条件を定義。
- `docs/requirements/`:
  - `HEARING_SHEET.md`: ヒアリング入力フォーム。
  - `REQUIREMENTS_TEMPLATE.md`: プロジェクト固有要件定義書のテンプレ（編集禁止）。
  - `SOW_TEMPLATE.md`: フェーズ別SOW（Statement of Work）のテンプレ。
  - `projects/`: プロジェクト別の要件定義書保存場所。
- `docs/rules/`: 開発・アーキテクチャ・SEO・セキュリティ・可観測性・可搬性・品質ゲート等の規約群。
- `docs/runbooks/RELEASE_CHECKLIST.md`: リリース前チェックリスト。

## 始め方（Definition of Ready）
1) `docs/requirements/HEARING_SHEET.md` を確認し、未記入項目をユーザーへ（要件定義フェーズに限り）一問一答でヒアリング。合意済みは以後再質問しない。
2) `docs/requirements/REQUIREMENTS_TEMPLATE.md` を複製し、`docs/requirements/projects/<project_slug>/REQUIREMENTS_<project_slug>.md` を作成（テンプレは編集しない）。
3) ヒアリング結果を転記し、TBD/リスク/矛盾を明示。対応方針を合意。
4) 要件が合意できたら、フェーズごとに SOW を作成・合意（テンプレ: `docs/requirements/SOW_TEMPLATE.md` → 保存: `docs/requirements/projects/<project_slug>/SOW_<phase>.md`。範囲/成果物/受入基準/リスクを明記）。
5) `docs/rules/QUALITY_GATES.md` を満たす見通しを立ててから実装開始。

## 開発・運用方針（抜粋）
- 環境: `dev / staging / production` を環境変数で切替。ブランチ例: `dev`→dev, `staging`→staging, `main`→prod。
- コンテナ: Docker Compose で開発・テストを完結させる想定。初期ポートは衝突しにくい帯域（例: 43000番台）から選び、設定で変更可能にする。
- 環境変数: リポジトリ直下の `.env` はコンテナ用（テンプレ `.env.example` をコミット）。Next.js の実行時キーは `frontend/.env.local` に集約し、テンプレ `frontend/.env.local.example` をコミットする。秘密はどちらも本番値をコミットしない。必須キーは起動時に検証して fail fast。
- 低ロックイン: データ層は Postgres 想定、ストレージは S3 互換抽象、認証や監視は差し替え可能な境界を設計。

## 品質ゲート（最小必須）
- Lint / Typecheck / Unit・Integration Test / Build
- Secret scan（例: gitleaks）
- Dependency vulnerability scan（例: OSV-Scanner）

推奨（将来必須化想定）: Lighthouse CI, Pa11y CI, OWASP ZAP Baseline（DAST）, Playwright E2E。

## SEO / セキュリティ標準
- SEO: `robots.txt` / `sitemap.xml` / 全ページの title・description・canonical・OGP/Twitter Card・必須構造化データ（Organization, WebSite, Breadcrumb）。
- セキュリティ: CSP を基本に、HSTS, X-Content-Type-Options, Referrer-Policy, Permissions-Policy など主要ヘッダーを標準適用。フォームは入力検証・CSRF/スパム対策・レート制限を設計に含める。

## AIエージェント利用時の注意
- 作業・質問・成果物は原則日本語。
- ヒアリングは要件定義フェーズのみ一問一答で進め、推測で要件を埋めない（合意済み事項は再質問しない）。
- 既存の疎結合・低ロックイン設計に反する提案をする場合は代替案と移行コストを明示。

## コントリビューションの流れ（例）
- 要件定義を確定 → 小さなタスクに分解 → ブランチ作成 → 必須品質ゲートを通過 → PR/レビュー → `main/staging/dev` へマージ。

## 今後の拡張
- Next.js アプリ本体や Docker Compose 設定、各種 CI ワークフローを順次追加予定。追加時も本READMEと `AGENTS.md` を最新の一次情報として更新してください。

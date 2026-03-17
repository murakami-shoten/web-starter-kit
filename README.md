# Web Starter Kit

[![License: MIT](https://img.shields.io/github/license/murakami-shoten/web-starter-kit)](LICENSE)
[![GitHub stars](https://img.shields.io/github/stars/murakami-shoten/web-starter-kit)](https://github.com/murakami-shoten/web-starter-kit/stargazers)
[![GitHub last commit](https://img.shields.io/github/last-commit/murakami-shoten/web-starter-kit)](https://github.com/murakami-shoten/web-starter-kit/commits/main)

このリポジトリは「あらゆるWebサイト構築」を素早く始められるテンプレート兼ベースプロジェクトです。要件定義から実装・テスト・保守計画までを一貫して進められる規範的なドキュメント群を備え、AIを活用した開発も、AIを使わないチーム開発も同じ手順で運用できます。

## 対象ユーザー

本プロジェクトは **Web開発・運用の基本的な流れを理解しているWeb制作者** を対象としています。具体的には、要件定義→設計→実装→テスト→デプロイ→保守のライフサイクルや、Git・Docker・CI/CDなどの基礎概念を把握していることを前提とします。Web開発未経験者向けのチュートリアルではありません。

## 特徴
- 要件定義ファースト: ヒアリングシート→要件定義書→リスク明示の流れを標準化。
- Next.js（App Router）+ TypeScript を前提とした設計指針を提供。
- SEO / セキュリティ / 可搬性 / 低ロックイン / 拡張性を国際標準・Google推奨・定石に沿って担保する規約付き。
- Docker 前提で、ホストに Node/npm が無くても開発・CI を再現可能な方針。
- AIエージェント利用時の運用ルールを明文化（日本語での逐次ヒアリング、一問一答）。

## リポジトリ構成
- `AGENTS.md`: AIエージェント向け作業ルール・不変条件（一次ソース）。
- `docs/requirements/`:
  - `HEARING_SHEET.md`: ヒアリング入力フォーム。
  - `REQUIREMENTS_TEMPLATE.md`: プロジェクト固有要件定義書のテンプレ（編集禁止）。
  - `SOW_TEMPLATE.md`: フェーズ別SOW（Statement of Work）のテンプレ。
  - `projects/`: プロジェクト別の要件定義書保存場所。
- `docs/rules/`: 開発・アーキテクチャ・SEO・セキュリティ・可観測性・可搬性・品質ゲート等の規約群。
- `docs/runbooks/RELEASE_CHECKLIST.md`: リリース前チェックリスト。

## 前提条件

- Git
- Docker Desktop（macOS / Windows WSL2）

## 利用開始（新規プロジェクトの作成）

本リポジトリをテンプレートとして新規プロジェクトを開始する手順:

### 方法A: GitHub の「Use this template」（推奨）
1. GitHub上で本リポジトリの「Use this template」→「Create a new repository」を選択
2. 新リポジトリ名を入力して作成
3. 作成されたリポジトリをローカルにクローン

### 方法B: 手動クローン
```bash
git clone <web-starter-kit-url> <new-project-name>
cd <new-project-name>
rm -rf .git
git init
git add .
git commit -m "chore: init from web-starter-kit template"
```

作成後、以下の「始め方（Definition of Ready）」に従って要件定義から進めてください。

## 始め方（Definition of Ready）
1) `docs/requirements/HEARING_SHEET.md` を確認し、未記入項目をユーザーへ（要件定義フェーズに限り）一問一答でヒアリング。合意済みは以後再質問しない。
2) `docs/requirements/REQUIREMENTS_TEMPLATE.md` を複製し、`docs/requirements/projects/<project_slug>/REQUIREMENTS_<project_slug>.md` を作成（テンプレは編集しない）。
3) ヒアリング結果を転記し、TBD/リスク/矛盾を明示。対応方針を合意。
4) 要件が合意できたら、フェーズごとに SOW を作成・合意（テンプレ: `docs/requirements/SOW_TEMPLATE.md` → 保存: `docs/requirements/projects/<project_slug>/SOW_<phase>.md`。範囲/成果物/受入基準/リスクを明記）。
5) `docs/rules/QUALITY_GATES.md` を満たす見通しを立ててから実装開始。

### 設計ドキュメントの方針

本プロジェクトでは **詳細設計書を独立した成果物として作成しません**。以下の3点がその役割を担います:

- **要件定義書**: 「何を作るか」（機能・非機能要件、制約）
- **ワイヤーフレーム/UIモック**: 「どう見せるか」（画面構成・レイアウト・要素配置・導線）— 画面レベルの詳細設計を兼ねる
- **SOW**: 「いつ・何を納品するか」（スコープ・成果物・受入基準）

バックエンド設計（API仕様・DB設計等）が必要な場合は、要件定義書またはSOWの成果物として個別に定義します。

> **Q. なぜ詳細設計書を作成しないのか？**
> 詳細設計書を「作らない」のではなく、より実用的な形に分解しています。従来のテキスト仕様書は「書いた時点で古くなる」「実装と乖離しやすい」「メンテされない」という課題があります。本プロジェクトでは、画面仕様は実際に動くワイヤーフレーム/HTMLモックで合意を取ることで認識のズレを防ぎ、スコープ・受入基準はSOWで明確化します。すべてGit管理されるため変更履歴も残り、納品時のトラブルも防げます。技術的に必要なドキュメント（API仕様書・DB設計書等）はSOWの成果物として個別に追加可能です。

## 開発・運用方針（抜粋）
- 環境: `dev / staging / production` を環境変数で切替。ブランチ例: `dev`→dev, `staging`→staging, `main`→prod。
- コンテナ: Docker Compose で開発・テストを完結させる想定。初期ポートは衝突しにくい帯域（例: 43000番台）から選び、設定で変更可能にする。
- 環境変数: リポジトリ直下の `.env` はコンテナ用（テンプレ `.env.example` をコミット）。Next.js の実行時キーは `frontend/.env.local` に集約し、テンプレ `frontend/.env.local.example` をコミットする。秘密はどちらも本番値をコミットしない。必須キーは起動時に検証して fail fast。
- 低ロックイン: データ層は Postgres 想定、ストレージは S3 互換抽象、認証や監視は差し替え可能な境界を設計。

## 品質ゲート（最小必須）
- Lint / Typecheck / Unit・Integration Test / Build
- Secret scan（例: gitleaks）
- Dependency vulnerability scan（例: OSV-Scanner）

推奨（将来必須化想定）: Lighthouse CI, Pa11y CI, OWASP ZAP Baseline（DAST）, Playwright E2E, CSS Bundle Size チェック（詳細は `docs/rules/PERFORMANCE_RULES.md`）。

## SEO / LLMO / セキュリティ標準
- SEO: `robots.txt` / `sitemap.xml` / 全ページの title・description・canonical・OGP/Twitter Card・必須構造化データ（Organization, WebSite, Breadcrumb）。
- LLMO: `llms.txt` によるLLM向けサイト情報の構造化提供（`docs/rules/LLMO_RULES.md` 参照）。
- セキュリティ: CSP を基本に、HSTS, X-Content-Type-Options, Referrer-Policy, Permissions-Policy など主要ヘッダーを標準適用。フォームは入力検証・CSRF/スパム対策・レート制限を設計に含める。
- メール送信: プロバイダ選定の意思決定ツリー、DNS認証（SPF/DKIM/DMARC）、低ロックイン設計パターンを標準化（`docs/rules/EMAIL_RULES.md` 参照）。

## AIエージェント利用時の注意

### 推奨モデル
- **要件定義・タスク分解**: Gemini 3 Pro 以上
- **詳細設計・実装**: Claude Opus 4.5 以上

- 作業・質問・成果物は原則日本語。
- ヒアリングは要件定義フェーズのみ一問一答で進め、推測で要件を埋めない（合意済み事項は再質問しない）。
- 既存の疎結合・低ロックイン設計に反する提案をする場合は代替案と移行コストを明示。

### Agent Skills について
本プロジェクトでは Agent Skills（`.gemini/` / `.agents/` 等のワークフロー定義）を**意図的に導入していません**。理由:
- AIエージェントごとにスキルディレクトリの規約が異なり、メンテナンスコストが増大する
- 本プロジェクトのルール群は「基準を示して判断を委ねる」参照型であり、固定手順に落とし込む手順型（Skills）とは性質が異なる
- プロジェクト種別の自由度が高く、汎用的な固定ワークフローを定義しにくい

代わりに `AGENTS.md`（+ `CLAUDE.md`）から `docs/rules/` を参照させるルール参照型の設計を採用しています。

## コントリビューションの流れ（例）
- 要件定義を確定 → 小さなタスクに分解 → ブランチ作成 → 必須品質ゲートを通過 → PR/レビュー → `main/staging/dev` へマージ。

## 今後の拡張（本テンプレプロジェクトとして）
- 保守運用体制テンプレートの整備:
  - 保守体制・責任分担表（RACI）テンプレート
  - 障害対応ランブック（インシデント対応・復旧手順）
  - SLA/SLO 定義テンプレート（稼働率目標・応答時間の合意書）
  - 定期運用チェックリスト（月次パッチ確認、バックアップ検証、SSL証明書更新等）
- GitHub コミュニティスタンダード準拠テンプレートの整備:
  - `CONTRIBUTING.md`（コントリビューションガイドライン）
  - `.github/ISSUE_TEMPLATE/`（Issue テンプレート）
  - `.github/PULL_REQUEST_TEMPLATE.md`（PR テンプレート）
  - `CODE_OF_CONDUCT.md`（行動規範）

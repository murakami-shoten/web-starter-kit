# AGENTS.md（AIエージェント共通ガイド）

> プロジェクト概要・対象ユーザー・リポジトリ構成・利用開始手順は `README.md` を参照すること。
> 本ファイルは **AIエージェント向けの作業ルール・不変条件** を定義する一次ソースである。

---

## 0. 重要：このリポジトリでの作業順序（必須）

**実装を始める前に、必ず要件定義を完了してください。推測で実装しないこと。**

1) `docs/requirements/HEARING_SHEET.md` を確認し、未記入項目を抽出  
2) 未記入項目は**ユーザーに質問**して回答を得る（推測禁止）  
3) まず `docs/requirements/REQUIREMENTS_TEMPLATE.md` を複製し、`docs/requirements/projects/<project_slug>/REQUIREMENTS_<project_slug>.md` を作成する（テンプレは編集しない）
4) 回答を新規作成した要件定義書に反映（TBDはTBDのまま明示）  
5) 要件の矛盾/未確定/リスク（SEO/法務/アクセシビリティ/セキュリティ/運用）を列挙して合意を取る  
6) 要件が合意できたら、フェーズごとにSOWを作成し合意する（テンプレ: `docs/requirements/SOW_TEMPLATE.md`、保存先: `docs/requirements/projects/<project_slug>/SOW_<phase>.md`）  
   - ※この時点で「リリースまでに必須だが未決定」の項目（アセット、文言等）がある場合は、別途 `docs/requirements/SOW_RELEASE_PREP_TEMPLATE.md` から `SOW_RELEASE_PREP.md` を作成し、開発と並行して解決する計画を立てること。  
7) `docs/rules/QUALITY_GATES.md` のゲートに沿ってタスク分解し、実装開始

---

## 1. 参照すべき規約（この順で読む）

- 開発規約: `docs/rules/DEV_RULES.md`
- アーキテクチャ/低ロックイン方針: `docs/rules/ARCHITECTURE_RULES.md`, `docs/rules/LOW_LOCKIN_RULES.md`
- SEO規約（Google推奨準拠）: `docs/rules/SEO_RULES.md`
- LLMO規約（LLM最適化 / llms.txt）: `docs/rules/LLMO_RULES.md`
- セキュリティ規約（CSP/ヘッダー/ASVS）: `docs/rules/SECURITY_RULES.md`
- 可観測性・ログ方針: `docs/rules/OBSERVABILITY_RULES.md`
- パフォーマンス規約（フォント/CWV）: `docs/rules/PERFORMANCE_RULES.md`
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
- コンテナ関連の環境変数は `docker-compose.yml` に直書きせず、リポジトリ直下の `.env` から読み込む（`.env` はコミットしない。テンプレとして `.env.example` を用意する）
- Next.js 用の環境変数は `frontend/.env.local` に集約し、テンプレとして `frontend/.env.local.example` を必ず用意する（本番/Preview もこのキーに合わせて設定する）。`.env.local*` はGitにコミットしない。
- npm / node / npx / lint / typecheck / format / format:check / test / build などのコマンドは**必ず Docker Compose 経由**で実行する（例: `docker compose run --rm frontend npm run lint`、`docker compose run --rm frontend npm run typecheck`、`docker compose run --rm frontend npm run format:check`）。ホストで npm / npx を直接実行する前提を置かない。
- コンテナの起動/停止/ログ/状態確認も docker compose に統一する（例: `docker compose up -d`, `docker compose stop`, `docker compose down`, `docker compose logs -f`, `docker compose ps`, `docker compose exec ...`）。`docker run` 直叩きは禁止。

### 2.3 SEO / セキュリティ
- SEOはGoogle推奨と整合し、技術要件（サイトマップ/メタ/構造化データ等）を標準実装する
- セキュリティはCSP/セキュリティヘッダーを標準装備し、脆弱性チェックをCI相当に必須化する（詳細は各規約）

### 2.4 プロジェクト構造
- Next.js アプリはリポジトリ直下ではなく、将来の拡張を見据えた `frontend/` ディレクトリに配置する（ルート直下を汚さず、他サービスを並列追加できる余地を確保する）

---

## 3. AIエージェントへの作業ルール（共通）

### 推奨AIモデル
- **要件定義・タスク洗い出し**: Gemini 3 Pro 以上
- **詳細設計・実装**: Claude Opus 4.5 以上


- 変更は最小単位で、意図と理由を説明する（なぜ必要か）
- **ユーザーとの対話・質問・Artifact作成は、原則として日本語で行うこと**
- **要件定義フェーズのヒアリングのみ、一度に全ての質問をせず、対話的に（一問一答または少数ずつ）進めること。合意済みの要件は以後繰り返し質問しないこと。**
- フロントエンドの実装/デザイン調整時は、AIエージェント自身がブラウザで挙動を確認できるよう `chrome-devtools-mcp` もしくは Playwright を必ず導入・利用し、コンソールログやレイアウト崩れを実機確認しながら作業する（手元での目視確認なしの推測修正を禁止）
  - ユーザー環境に Chrome + `chrome-devtools-mcp` が導入済みならそれを優先利用する。未導入の場合はヒアリングで許可を得てセットアップを提案し、許可が無い/環境的に難しい場合は Playwright のスクリーンショット確認など代替手段を取る
- フロント/バックエンド共通で「車輪の再発明」を避ける。実装前に既存の共通関数・コンポーネント・ユーティリティ・ライブラリを調査し、再利用や抽出を優先する（重複実装禁止）。
  - 共通化に伴う軽微〜中規模のリファクタは許容するが、破壊的変更（API互換性喪失、大量ファイル移動等）は必ずユーザーの許可を得てから行う。

- 既存設計（疎結合・低ロックイン）に反する提案をする場合は、**代替案**と**移行コスト**も提示する
- 実装前に `docs/requirements/REQUIREMENTS.md` に立ち戻り、要件と一致しているか確認する
- セキュリティ関連（CSP/認証/権限/入力）を変更する場合は、必ず `docs/rules/SECURITY_RULES.md` のチェック項目に照らす
- ワイヤーフレームが必要な場合は、AIエージェントがリポジトリ内で確認可能な静的HTMLモックを作成すること。ユーザーにFigma等の外部ツールでの作成を求めない（要件定義書やSOWにもユーザー作業として記載しない）
- APIキーや秘密情報をヒアリングで受領した場合は、その場で内容を `.env.tmp`（Git管理外）に記録し、シートやIssueには「取得済/未取得」と保管場所のみ記載する。未取得の場合はTBDのまま残し、実装開始前に再確認する。
- 監視・バックアップについては、商用サービスと併せて無料/OSS構成（例: OSSエージェント＋GitHub/クラウドスナップショット等）の可否をヒアリングで提案・すり合わせる。採用可否とコスト/リスクをユーザー合意のうえで決定する。
- **禁止事項**: 投げやり・他責・サボタージュ・虚偽報告は厳禁（進捗/問題は正直に報告する）

## 5. 実装完了後の必須作業（品質保証と整理）

1.  **品質保証レポートの作成 (QUALITY_REPORT.md)**
    - 実装完了後、`docs/requirements/QUALITY_REPORT_TEMPLATE.md` を使用して `docs/requirements/projects/<project_slug>/` にレポートを作成すること。
    - セキュリティ、アクセシビリティ、バグゼロ、堅牢性の証拠（エビデンス）として、クライアントに提示できるレベルで記述する。各テストの結果やログへのリンクを含めること。

2.  **README.md のリファクタリング**
    - プロジェクト固有の実装が完了したら、ルートの `README.md` をそのプロジェクト専用の内容に書き直すこと。
    - スターターキット由来の汎用的な情報は削除または別ファイルへ移動し、プロジェクトの概要、セットアップ方法、主要な機能にフォーカスする。
    - 詳細なドキュメントは `README.md` に詰め込まず、`docs/requirements/projects/<project_slug>/` や `docs/runbooks/` 配下に整理し、リンクで参照させる構造にすること。

---

## 6. 実装開始の合図（Definition of Ready）

`README.md` の「始め方（Definition of Ready）」に記載された条件が全て揃ってから実装を開始すること。

---

（作成日: 2026-01-27 JST）

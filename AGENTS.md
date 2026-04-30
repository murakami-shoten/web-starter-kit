# AGENTS.md（AIエージェント共通ガイド）

> プロジェクト概要・対象ユーザー・リポジトリ構成・利用開始手順は `README.md` を参照すること。
> 本ファイルは **AIエージェント向けの作業ルール・不変条件** を定義する一次ソースである。

---

## 0. 重要：このリポジトリでの作業順序（必須）

**実装を始める前に、必ず要件定義を完了してください。推測で実装しないこと。**

ヒアリングから要件確定までの具体的な手順は `docs/governance/rules/HEARING_RULES.md` を参照すること。  
**最初にヒアリング深度（L1: 初期構築 / L2: 機能追加 / L3: バグ修正）を判定する**（§1.1）。

6) 要件が合意できたら、フェーズごとにSOWを作成し合意する（テンプレ: `docs/governance/requirements/SOW_TEMPLATE.md`、保存先: `docs/projects/<project_slug>/SOW_<phase>.md`）  
   - ※この時点で「リリースまでに必須だが未決定」の項目（アセット、文言等）がある場合は、別途 `docs/governance/requirements/SOW_RELEASE_PREP_TEMPLATE.md` から `SOW_RELEASE_PREP.md` を作成し、開発と並行して解決する計画を立てること。  
7) `docs/governance/rules/QUALITY_GATES.md` のゲートに沿ってタスク分解し、実装開始

### 設計ドキュメントの方針

`README.md`「設計ドキュメントの方針」を参照すること。詳細設計書は独立した成果物として作成せず、要件定義書・ワイヤーフレーム/UIモック・SOWがその役割を担う。

### 機能仕様書（Feature Spec）の作成判断

個別機能の要件・設計・タスクを1セットで管理する仕様書テンプレート（`docs/governance/requirements/FEATURE_SPEC_TEMPLATE.md`）を用意している。以下のいずれかに該当する機能は、個別の機能仕様書を作成する:

- 条件分岐やエラーハンドリングが3パターン以上ある
- 外部サービスとの連携がある（API / CMS / メール送信等）
- 状態管理や非同期処理を含む
- 複数の画面/コンポーネントにまたがる

該当しない機能（静的ページ、単純なレイアウト等）は要件定義書 + SOW で十分。保存先: `docs/projects/<project_slug>/specs/<feature_slug>.md`

### バグ修正仕様書（Bugfix Spec）の作成判断

複雑なバグの根本原因分析・修正設計・リグレッション防止を構造化するテンプレート（`docs/governance/requirements/BUGFIX_SPEC_TEMPLATE.md`）を用意している。以下のいずれかに該当するバグは、バグ修正仕様書を作成する:

- クリティカルパス（CV導線・決済・認証等）のバグ
- 過去の修正でリグレッションが発生した箇所
- 根本原因がすぐに特定できない複雑なバグ
- コンプライアンス/セキュリティに関わるバグ

該当しないバグ（タイポ、単純なロジックエラー、1行修正で解決するもの）は即席修正で十分。保存先: `docs/projects/<project_slug>/specs/bugfix-<issue_slug>.md`

### ワークフロー選択（Requirements-First / Design-First）

ワークフロー選択の詳細は `docs/governance/rules/HEARING_RULES.md` §4 を参照すること。

**原則: Requirements-First**（ヒアリング → 要件定義 → SOW → 実装）を標準とする。

---

## 1. 参照すべき規約（この順で読む）

- ヒアリング規約: `docs/governance/rules/HEARING_RULES.md`
- 開発規約: `docs/governance/rules/DEV_RULES.md`
- アーキテクチャ/低ロックイン方針: `docs/governance/rules/ARCHITECTURE_RULES.md`, `docs/governance/rules/LOW_LOCKIN_RULES.md`
- UI/UXデザイン規約（ISO 9241/Nielsen/設計原則）: `docs/governance/rules/DESIGN_RULES.md`
- SEO規約（Google推奨準拠）: `docs/governance/rules/SEO_RULES.md`
- LLMO規約（LLM最適化 / llms.txt）: `docs/governance/rules/LLMO_RULES.md`
- セキュリティ規約（CSP/ヘッダー/ASVS）: `docs/governance/rules/SECURITY_RULES.md`
- メール送信規約（プロバイダ選定/DNS認証/低ロックイン）: `docs/governance/rules/EMAIL_RULES.md`
- 可観測性・ログ方針: `docs/governance/rules/OBSERVABILITY_RULES.md`
- パフォーマンス規約（フォント/CWV）: `docs/governance/rules/PERFORMANCE_RULES.md`
- コンテンツ可搬性（MDX/運用）: `docs/governance/rules/CONTENT_RULES.md`
- 品質ゲート（テスト/脆弱性/性能/a11y）: `docs/governance/rules/QUALITY_GATES.md`
- リリース運用: `docs/governance/runbooks/RELEASE_CHECKLIST.md`

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
- Next.js 用の環境変数は `<webdir>/.env.local` に集約し、テンプレとして `<webdir>/.env.local.example` を必ず用意する（本番/Preview もこのキーに合わせて設定する）。`.env.local*` はGitにコミットしない。※ `<webdir>` はプロジェクトのWebアプリディレクトリ名（デフォルト推奨: `web/`、プロジェクト判断で変更可）
- npm / node / npx / lint / typecheck / format / format:check / test / build などのコマンドは**必ず Docker Compose 経由**で実行する（例: `docker compose run --rm frontend npm run lint`、`docker compose run --rm frontend npm run typecheck`、`docker compose run --rm frontend npm run format:check`）。ホストで npm / npx を直接実行する前提を置かない。
- コンテナの起動/停止/ログ/状態確認も docker compose に統一する（例: `docker compose up -d`, `docker compose stop`, `docker compose down`, `docker compose logs -f`, `docker compose ps`, `docker compose exec ...`）。`docker run` 直叩きは禁止。

### 2.3 SEO / セキュリティ
- SEOはGoogle推奨と整合し、技術要件（サイトマップ/メタ/構造化データ等）を標準実装する
- セキュリティはCSP/セキュリティヘッダーを標準装備し、脆弱性チェックをCI相当に必須化する（詳細は各規約）

### 2.4 プロジェクト構造
- Next.js アプリはリポジトリ直下ではなく、将来の拡張を見据えた**専用のサブディレクトリ**に配置する（デフォルト推奨: `web/`。プロジェクト判断で `frontend/` 等に変更可。ルート直下を汚さず、他サービスを並列追加できる余地を確保する）

### 2.5 規約サブモジュール（`docs/governance/`）の導入と保護
- `docs/governance/` は独立リポジトリ（[nextjs-web-governance](https://github.com/murakami-shoten/nextjs-web-governance)）の Git サブモジュールとしてプロジェクト作成時に導入する（手順は `README.md`「利用開始」を参照）。本テンプレートには含まれないため、プロジェクト作成後に必ず `git submodule add` で追加すること。
- **外部プロジェクト（spec-kit 等）からも参照されている**ため、governance リポジトリの構造的改変（ディレクトリ名変更、ファイル移動・削除等）を行う場合は `docs/governance/README.md`「⚠️ 構造変更に関する注意」セクションに従い、必ずユーザーの明示的許可を得ること。
- governance リポジトリへの変更は、プロジェクト側のサブモジュール参照の更新（`git add docs/governance && git commit`）も忘れずに行うこと

---

## 3. AIエージェントへの作業ルール（共通）

### 推奨AIモデル
- **要件定義・タスク洗い出し**: Gemini 3 Pro 以上
- **詳細設計・実装**: Claude Opus 4.5 以上


- 変更は最小単位で、意図と理由を説明する（なぜ必要か）
- **ユーザーとの対話・質問・Artifact作成は、原則として日本語で行うこと**
- ヒアリングの進め方（一問一答・推測禁止・合意済再質問禁止）は `docs/governance/rules/HEARING_RULES.md` §2.2 を参照すること
- フロントエンドの実装/デザイン調整時は、AIエージェント自身がブラウザで挙動を確認できるよう `chrome-devtools-mcp` もしくは Playwright を必ず導入・利用し、コンソールログやレイアウト崩れを実機確認しながら作業する（手元での目視確認なしの推測修正を禁止）
  - ユーザー環境に Chrome + `chrome-devtools-mcp` が導入済みならそれを優先利用する。未導入の場合はヒアリングで許可を得てセットアップを提案し、許可が無い/環境的に難しい場合は Playwright のスクリーンショット確認など代替手段を取る
- フロント/バックエンド共通で「車輪の再発明」を避ける。実装前に既存の共通関数・コンポーネント・ユーティリティ・ライブラリを調査し、再利用や抽出を優先する（重複実装禁止）。
  - 共通化に伴う軽微〜中規模のリファクタは許容するが、破壊的変更（API互換性喪失、大量ファイル移動等）は必ずユーザーの許可を得てから行う。

- 既存設計（疎結合・低ロックイン）に反する提案をする場合は、**代替案**と**移行コスト**も提示する
- 実装前に `docs/governance/requirements/REQUIREMENTS_TEMPLATE.md` に立ち戻り、要件と一致しているか確認する
- セキュリティ関連（CSP/認証/権限/入力）を変更する場合は、必ず `docs/governance/rules/SECURITY_RULES.md` のチェック項目に照らす
- ワイヤーフレーム/画面構成が必要な場合は、以下の順で作成方法を決定する:
  1. **ユーザー提供**: まずユーザーに提供物（Figma等で作成済みのもの）の有無を確認する。あればそれを基に実装する
  2. **外部ツール出力の取り込み**: Google Stitch等の外部ツールで生成したワイヤーフレームがある場合、出力形式に応じて取り込む。画像出力→デザインリファレンスとして参照。HTML/コード出力→`docs/wireframes/`に配置し、プロジェクトの技術スタック・コーディング規約に合わせてAIエージェントが再実装する（外部ツールの出力コードをそのまま使わない）
  3. **AIエージェントが作成**: 上記いずれもない場合、AIエージェントがリポジトリ内に静的HTMLモックとして作成・配置する。ユーザーにFigma等での新規作成を要求しない（要件定義書やSOWにもユーザー作業として記載しない）
- ワイヤーフレーム/UIモックを作成する場合（上記いずれの方法でも）は、`docs/governance/rules/DESIGN_RULES.md` のUI/UX設計原則に準拠すること。デザイン判断の根拠は同規約または付録のリファレンスに基づいて説明できること
- 承認済みのワイヤーフレーム/UIモックが存在する場合、実装時に画面構成・レイアウト・要素配置の基準として参照し準拠すること。技術的制約や改善提案によりワイヤーフレームから乖離する場合は、変更箇所と理由をユーザーに説明し合意を得てから実装する
- **ワイヤーフレームと SOW の工程順序**: 要件定義合意後、実装SOWを作成する前にワイヤーフレームを作成・承認する。ワイヤーフレームが確定しないと画面レベルの受入基準が書けないため、SOW §4（受入基準チェックリスト）の精度が落ちる。フェーズ分割する場合は「設計フェーズSOW → ワイヤーフレーム作成・承認 → 実装フェーズSOW」の順とする
- APIキーや秘密情報が必要な場合は、ヒアリングで取得状況（取得済/未取得）を確認し、シートやIssueには取得状況のみ記載する。秘密値の配置（`.env` / `.env.local` 等への設定）はユーザーに依頼し、AIエージェントは必要なキー名・設定先・用途を案内すること。未取得の場合はTBDのまま残し、実装開始前に再確認する。
- 監視・バックアップについては、商用サービスと併せて無料/OSS構成（例: OSSエージェント＋GitHub/クラウドスナップショット等）の可否をヒアリングで提案・すり合わせる。採用可否とコスト/リスクをユーザー合意のうえで決定する。
- **禁止事項**: 投げやり・他責・サボタージュ・虚偽報告は厳禁（進捗/問題は正直に報告する）

## 5. 実装完了後の必須作業（品質保証と整理）

1.  **品質保証レポートの作成 (QUALITY_REPORT.md)**
    - 実装完了後、`docs/governance/requirements/QUALITY_REPORT_TEMPLATE.md` を使用して `docs/projects/<project_slug>/` にレポートを作成すること。
    - セキュリティ、アクセシビリティ、バグゼロ、堅牢性の証拠（エビデンス）として、クライアントに提示できるレベルで記述する。各テストの結果やログへのリンクを含めること。

2.  **README.md のリファクタリング**
    - プロジェクト固有の実装が完了したら、ルートの `README.md` をそのプロジェクト専用の内容に書き直すこと。
    - スターターキット由来の汎用的な情報は削除または別ファイルへ移動し、プロジェクトの概要、セットアップ方法、主要な機能にフォーカスする。
    - 詳細なドキュメントは `README.md` に詰め込まず、`docs/projects/<project_slug>/` や `docs/governance/runbooks/` 配下に整理し、リンクで参照させる構造にすること。

---

## 6. 実装開始の合図（Definition of Ready）

`README.md` の「始め方（Definition of Ready）」に記載された条件が全て揃ってから実装を開始すること。

---

（作成日: 2026-01-27 JST）

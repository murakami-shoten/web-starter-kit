# 開発規約（DEV_RULES）

（作成日: 2026-01-27 JST）

---

## 1. 言語・フレームワークの前提

- Next.js（App Router）+ TypeScript を前提
- 「疎結合・拡張性・低ロックイン」を最優先に設計する
- Next.js アプリはリポジトリ直下ではなく `frontend/` ディレクトリに配置し、将来のBFF/worker/CLI等を並列追加できるモノレポ構造を前提にする

---

## 2. コーディング規約（必須）

### 2.1 TypeScript
- `strict: true` を前提
- `any` は原則禁止（どうしても必要なら理由をコメントで残す）
- 型の境界は外部I/O（環境変数、HTTP、DB、外部API）で明確にする

### 2.2 ESLint
- `eslint-config-next/core-web-vitals`（Core Web Vitals ルール含む）を使用する
- Prettier との競合を防止するため `eslint-config-prettier` を併用する
- `eslint.config.js`（Flat Config）の構成例:

```javascript
const nextConfig = require("eslint-config-next/core-web-vitals");
const prettierConfig = require("eslint-config-prettier");

module.exports = [
  { ignores: [".next", ".next-dev", ".next-build", ".next-e2e", "node_modules"] },
  ...nextConfig,
  prettierConfig,
];
```

### 2.3 命名/構造
- 役割で分離する（UI / domain / infra / lib）
- 「機能ごと」かつ「依存方向が一方向」になるように配置する
- import は上位レイヤから下位レイヤへの依存のみ（逆は禁止）
- 新規実装前に既存の共通関数・コンポーネント・ユーティリティ・ライブラリを確認し、再利用または共通化を優先する（重複実装＝車輪の再発明を避ける）
 - 共通化に伴う軽微〜中規模のリファクタは許容。API互換を壊す、広範な移動を伴う等の破壊的リファクタは実施前にユーザーの許可を得ること。

### 2.4 型チェック（TypeScript）
- `tsc --noEmit` による型チェックを品質ゲートに含める（`npm run typecheck`）
- ビルド（`next build`）でも型チェックは実行されるが、型チェック単体を高速に回す手段として `typecheck` script を独立して用意する

### 2.5 フォーマット（Prettier）
- Prettier でコードフォーマットを統一する（設定: `frontend/.prettierrc.json`）
- `npm run format:check` を品質ゲートに含める（差分検知用）
- 自動修正は `npm run format` で実行する
- ESLint の書式系ルールは `eslint-config-prettier` で無効化し、フォーマットは Prettier に一元化する

### 2.6 コード品質ツールの初期セットアップ（派生プロジェクト向け）

派生プロジェクトの作成時、以下を必ず準備すること:

**`package.json` scripts:**

```json
"typecheck": "tsc --noEmit",
"format": "prettier --write 'src/**/*.{ts,tsx,js,jsx,css,json}'",
"format:check": "prettier --check 'src/**/*.{ts,tsx,js,jsx,css,json}'"
```

**`devDependencies` に追加:**

```
prettier
eslint-config-prettier
```

**設定ファイル:**

- `frontend/.prettierrc.json` — Prettier の書式設定
- `frontend/.prettierignore` — フォーマット対象外の指定

### 2.7 ログ
- ローカルはコンソール（開発体験を優先）
- staging/prod はデプロイ先の管理画面ログで追える設計にする
- 例外や失敗時は「原因」「入力（マスク）」「相関ID（あれば）」を含める

### 2.8 定数管理（選択肢・タブ・ステータス等）

UI の選択肢・タブ・フィルタ・ステータスなど、決まった値の集合を扱う場合は **定数として一元管理** し、コンポーネントへの直書きを禁止する。

**ルール:**
- 値の集合は `as const` 配列で定義し、union 型を導出する
- 定数は機能ドメインごとに `constants.ts`（例: `src/features/portfolio/constants.ts`）に集約する
- UIラベルが必要な場合はマッピングオブジェクトも同ファイルで定義する
- コンポーネントや API ハンドラでは定数をインポートして使用し、文字列リテラルを散在させない

**例:**

```typescript
// src/features/portfolio/constants.ts
export const SORT_OPTIONS = ["name", "value", "change"] as const;
export type SortOption = (typeof SORT_OPTIONS)[number];

export const SORT_LABELS: Record<SortOption, string> = {
  name: "名前順",
  value: "評価額順",
  change: "変動率順",
};
```

**根拠:** 値の散在はタイポ・不整合・改修漏れの温床になる。定数化により型安全性が担保され、変更時の影響範囲も明確になる。

---

## 3. Git運用（必須）

- main / staging / dev を基本ブランチとして運用
- PR（またはマージ）時点で品質ゲートを必ず通す
- 変更は小さく、レビューしやすい単位でコミット

### 3.1 コミットメッセージ（Conventional Commits 準拠）

コミットメッセージは [Conventional Commits](https://www.conventionalcommits.org/) の規約に従うこと。AIエージェントも同一ルールに従う。

**形式:**

```
<type>(<scope>): <subject>

[body]

[footer]
```

**type（必須・英語固定）:**

| type | 用途 |
|---|---|
| `feat` | 新機能 |
| `fix` | バグ修正 |
| `docs` | ドキュメントのみの変更 |
| `style` | コードの意味に影響しない変更（空白、フォーマット等） |
| `refactor` | バグ修正でも機能追加でもないコード変更 |
| `perf` | パフォーマンス改善 |
| `test` | テストの追加・修正 |
| `build` | ビルドシステムや外部依存の変更 |
| `ci` | CI設定の変更 |
| `chore` | 上記いずれにも当てはまらない雑務 |

**scope（任意・英語推奨）:** 変更対象のコンポーネントや機能領域（例: `contact`, `seo`, `auth`, `docker`）

**subject（必須・日本語許容）:** 変更内容の簡潔な説明。先頭を大文字にしない。末尾にピリオドを付けない。

**Breaking Change:** `type` の後に `!` を付与するか、フッターに `BREAKING CHANGE:` を記載する。

**例:**

```bash
feat(contact): お問い合わせフォームにバリデーション追加
fix(seo): OGP画像のパス修正
docs: ヒアリングシートに監視項目を追加
refactor!: API認証ミドルウェアの構造を変更
chore: init from web-starter-kit template
```

### 3.2 Git Hooks（推奨）

品質ゲート（`QUALITY_GATES.md`）の一部をコミット時に自動実行し、問題を早期に検出する。全ゲートを hooks で実行するのではなく、**数秒で終わる軽量なチェックのみ**を対象とする。

**推奨ツール構成:**

| ツール | 役割 |
|---|---|
| [husky](https://typicode.github.io/husky/) | Git hooks の管理（`.husky/` に格納） |
| [lint-staged](https://github.com/lint-staged/lint-staged) | 変更ファイルのみに lint / format を実行 |
| [commitlint](https://commitlint.js.org/) | Conventional Commits のメッセージ検証 |

**hooks で実行する推奨チェック:**

| hook | 実行内容 | 所要時間目安 |
|---|---|---|
| `pre-commit` | lint-staged（lint + format:check、変更ファイルのみ） | 数秒 |
| `commit-msg` | commitlint（メッセージ形式検証） | 1秒未満 |

**hooks で実行しないもの（重すぎるため）:** typecheck / test / build / secret scan / 脆弱性 scan → これらはデプロイ前の品質ゲート全体実行 or CI で行う。

> **Docker 前提との例外**: Git hooks は**ホスト側の Git が実行する**ため、hooks 内のコマンドはホスト環境に依存する。  
> - ホストに Node.js がある場合: husky / lint-staged がそのまま動作する  
> - ホストに Node.js がない場合: hooks 内で `docker compose run --rm frontend npx ...` を呼ぶか、hooks を無効化して CI に任せる（`QUALITY_GATES.md` の構成 C）

### 3.3 CI/CD（プロジェクト判断）

CI/CD を導入するかは `HEARING_SHEET.md` §10 でプロジェクトごとに合意する。導入する場合の指針:

- **推奨サービス**: GitHub Actions（リポジトリと統合しやすく、無料枠あり）
- **PR 時**: `QUALITY_GATES.md` §2 の必須ゲートを全項目自動実行する
- **マージ時**: ブランチに応じた環境（dev / staging / prod）へのデプロイをトリガーする
- **ワークフロー設計**: `QUALITY_GATES.md` のゲート定義に従い、将来の推奨ゲート追加にも対応しやすい構成にする
- **Docker 利用**: CI 上でも `docker compose` 経由でゲートを実行し、ローカルとの一貫性を保つ

---

## 4. 環境変数（必須）

- `.env*` はテンプレのみコミット可（秘密は不可）
- `env.example` を用意し、必須キー/意味/例を記載する
- 実行時に必須環境変数が無ければ起動時に落とす（fail fast）
- コンテナ関連の環境変数は `docker-compose.yml` へ直書きせず、リポジトリ直下の `.env` から参照する（テンプレは `.env.example`）
- Next.js 実行時の環境変数は `frontend/.env.local` に集約し、テンプレとして `frontend/.env.local.example` をコミットする（`.env.local*` はコミット禁止）。本番/Preview もこのキー名に合わせて設定する。
- ヒアリングで受け取ったAPIキーやトークンは `.env.tmp`（Git管理外）に一次保存し、鍵そのものをドキュメント/Issueに記載しない。未取得のキーはTBDとして残し、実装開始前に再確認する。
- **`NODE_ENV` を `.env` / `.env.local` / `.env.example` 等で明示的に設定しないこと。** Next.js は `next dev` で `development`、`next build` / `next start` で `production` を自動設定する。`.env` で `NODE_ENV=development` を明示すると、`next build` 時にも `development` が適用され、`/_global-error` 等のプリレンダリングでコンテキスト初期化に失敗しビルドがクラッシュする。Next.js 自身も `"You are using a non-standard NODE_ENV value"` と警告を出す。

---

## 5. コンテナ前提（必須）

- Docker Compose で dev/test を起動できること
- ホストにNode/npmが無くても `docker compose up` で動くこと
- ポートは衝突を避ける（例: 43100〜43200帯など）＋変更可能にする
- npm/node関連コマンド（install/run/lint/test/build/npx）はホストで直接叩かず、必ず `docker compose run --rm <service>` などコンテナ経由で実行する。ホスト実行を前提にした手順やスクリプトを禁止する。
- コンテナのライフサイクル操作も docker compose に統一する（`up -d` / `stop` / `down` / `logs` / `ps` / `exec` 等）。`docker run` 直叩きや compose を経由しない運用を前提にしない。

---

## 6. 依存関係ポリシー

- 追加依存は「なぜ必要か」をPRに書く
- 原則としてミドルウェア（Next.js等）・ライブラリは**最新バージョン**を採用すること
  - ただし、最新版に既知の重大な問題や脆弱性が確認されている場合は、回避可能な最も新しいStableバージョンを採用する
- ロックイン度が高いBaaS/SDKを入れる場合は、抽象化レイヤを設ける
- セキュリティ/品質ツールはOSS優先（詳細は QUALITY_GATES）

### フォントパッケージ

- CJK（日本語・中国語・韓国語）フォントを使う場合は `@fontsource-variable/*` パッケージを使用し、`next/font/google` は使わない（理由: PERFORMANCE_RULES 参照）
- ラテン文字フォント（Inter, Manrope 等）は `next/font/google` で問題ない
- フォント追加時は必ずビルド後の CSS チャンクサイズを確認する

---

## 7. ドキュメント運用

- 「ルール」は `docs/rules/` に集約（ここが真実）
- 「要件」は `docs/requirements/` に集約（実装の起点）
- 実装開始前に必ず要件の合意を取る（AGENTS.md参照）

---

## 8. App Router 既知課題と対策

### 8.1 ページ遷移時のスクロールリセット

Next.js App Router の `scrollRestoration` はブラウザ依存で不安定であり、ページ遷移後にスクロール位置が中途半端な位置に残ることがある（ヒーローやタイトルが見切れる）。

**対策**: `usePathname` + `window.scrollTo(0, 0)` で遷移時にページトップへリセットする。これは Next.js コミュニティで広く採用されているパターン。

```tsx
"use client";

import { useEffect } from "react";
import { usePathname } from "next/navigation";

export function useScrollToTopOnNavigate() {
  const pathname = usePathname();

  useEffect(() => {
    window.scrollTo(0, 0);
  }, [pathname]);
}
```

- この Hook をレイアウトまたは既存の Client Component（例: スクロールトップボタン）に組み込む
- `usePathname` は軽量な Hook であり、パフォーマンスへの影響は無視できる

### 8.2 カスタムエラーページ（必須）

Next.js デフォルトのエラーページ（白背景に黒文字のみ）はそのまま使用せず、**サイトのデザインに合った独自のエラーページを実装する**こと。

**必須ファイル:**

| ファイル | 役割 | 要件 |
|---|---|---|
| `app/not-found.tsx` | 404（ページ未検出） | 共通レイアウト（ヘッダー/フッター/ナビ）を含め、トップページや主要ページへの導線を提供する |
| `app/error.tsx` | ランタイムエラー（Client Component） | エラーメッセージとリトライボタンを表示し、ユーザーが操作を継続できるようにする |
| `app/global-error.tsx` | ルートレイアウト崩壊時のフォールバック | `<html>` / `<body>` を自前で含む最小限のエラーページ。トップへの導線を提供する |

**根拠:** デフォルトのエラーページはブランドの一貫性を損ない、ユーザーに「壊れたサイト」という印象を与える。適切なエラーページはユーザーの離脱を防ぎ、サイト内回遊を維持する。

---

## 9. CMS連携の実装注意事項

### 9.1 キャッシュ戦略の選択指針

ヘッドレスCMS（Storyblok / Contentful / microCMS 等）と連携するページでは、コンテンツの更新頻度と即時反映の要否に応じてキャッシュ戦略を選択する。

| 戦略 | ユースケース | 特徴 |
|---|---|---|
| **ISR**（`revalidate: N`） | ニュース一覧・ブログ記事等、数分〜数時間の遅延が許容されるページ | ビルド不要でCDNキャッシュを更新。パフォーマンスと鮮度のバランスが良い |
| **SSR**（`force-dynamic`） | プレビュー・下書き確認・リアルタイム反映が必要なページ | リクエストごとにCMSを取得。Webhook連動で `revalidateTag` / `revalidatePath` を使う場合はISR + On-Demand Revalidation が推奨 |
| **Static**（ビルド時生成） | 会社概要・プライバシーポリシー等、めったに更新しないページ | 最速だが更新時に再ビルドが必要 |

- デフォルトは **ISR**（`revalidate: 60` 等）を推奨。要件に応じて調整する
- `force-dynamic` の多用はサーバー負荷とレスポンス速度に影響するため、必要なページにのみ限定する

### 9.2 `.next` ディレクトリ競合対策（distDir 分離）

開発サーバーと E2E テストコンテナが同時に `.next` ディレクトリを使用すると、ビルドキャッシュの競合やファイルロックが発生する。

**対策**: E2E テスト用コンテナの `next.config.mjs` で `distDir` を分離する。

```js
// 例: e2e 用設定（環境変数で切替）
const nextConfig = {
  distDir: process.env.NEXT_DIST_DIR || '.next',
  // ...
};
```

- `docker-compose.yml` の E2E サービスで `NEXT_DIST_DIR=.next-e2e` を設定
- ボリュームマウント時に `.next` と `.next-e2e` が干渉しないよう注意

### 9.3 CMSプレビュー時の HTTPS 要件

ヘッドレスCMS の Webhook やプレビュー機能は **HTTPS エンドポイントを前提** とすることが多い（Storyblok のビジュアルエディタ等）。

**ローカル開発での対策**:
- `ngrok` や `cloudflared` 等のトンネルツールを使用して、ローカルの開発サーバーを一時的にHTTPSで公開する
- トンネルURLをCMS側のプレビューURLに設定する
- トンネルツールの無料プランでは URL が毎回変わる場合があるため、CMS側の設定更新手順をチームで共有すること

```bash
# 例: ngrok でローカル 43000 番ポートを公開
ngrok http 43000
```

- 本番・ステージングはデプロイ先が HTTPS を提供するため、この対策はローカル開発環境のみで必要

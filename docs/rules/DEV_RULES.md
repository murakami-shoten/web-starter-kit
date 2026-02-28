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

---

## 3. Git運用（推奨）

- main / staging / dev を基本ブランチとして運用
- PR（またはマージ）時点で品質ゲートを必ず通す
- 変更は小さく、レビューしやすい単位でコミット

---

## 4. 環境変数（必須）

- `.env*` はテンプレのみコミット可（秘密は不可）
- `env.example` を用意し、必須キー/意味/例を記載する
- 実行時に必須環境変数が無ければ起動時に落とす（fail fast）
- コンテナ関連の環境変数は `docker-compose.yml` へ直書きせず、リポジトリ直下の `.env` から参照する（テンプレは `.env.example`）
- Next.js 実行時の環境変数は `frontend/.env.local` に集約し、テンプレとして `frontend/.env.local.example` をコミットする（`.env.local*` はコミット禁止）。本番/Preview もこのキー名に合わせて設定する。
- ヒアリングで受け取ったAPIキーやトークンは `.env.tmp`（Git管理外）に一次保存し、鍵そのものをドキュメント/Issueに記載しない。未取得のキーはTBDとして残し、実装開始前に再確認する。

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

# アーキテクチャ規約（ARCHITECTURE_RULES）

（作成日: 2026-01-27 JST）

---

## 1. ゴール

- 疎結合で拡張しやすい
- ベンダーロックインされにくい（現実ラインを決める）
- 運用しやすい（環境切替、ブランチデプロイ、再現性）
- セキュリティ/SEO/品質が自動ゲートで担保される

---

## 2. 推奨アーキテクチャ（基本形）

- Next.js（App Router）を中心に
  - UI（SSR/ISR/SSG）
  - 軽量API（Route Handlers）
  - 配置はリポジトリ直下ではなく、将来の多サービス展開を見据えて `frontend/` ディレクトリ配下に置く
- 重い処理は将来 Worker/BFF に分離できる設計を維持する
- DB/Storage/Auth は差し替え可能な"境界"を作る（infra層）

### 2.1 設計原則（Clean Architecture + DDD Lite）

本スターターキットでは **Clean Architecture の原則** と **DDD（ドメイン駆動設計）のエッセンス** を、Next.js App Router に最適化した形で採用する。フル DDD（集約ルート、リポジトリパターン、CQRS 等）は対象規模に対して過剰であるため、以下の「実用的な原則」に限定する。

#### 依存方向の制約（Dependency Rule）

依存は **外側（UI / フレームワーク）から内側（ビジネスロジック）** への一方向のみ許可する。内側のレイヤーは外側のレイヤーを知らない。

```
UI (React Components)
  ↓ 依存OK
Features / Domain（ビジネスロジック）
  ↓ 依存OK
Lib / Infra（DB, 外部API, 認証）

※ 逆方向（Infra → Domain、Domain → UI）の import は禁止
```

#### レイヤーの責務

| レイヤー | 責務 | 依存してよいもの | 例 |
|---|---|---|---|
| **UI（Presentation）** | 画面描画・ユーザー操作の受付 | Features, Lib, Components | `app/`, `components/` |
| **Features / Domain** | ビジネスロジック・ドメイン固有の計算・バリデーション・状態遷移 | Lib, Utils | `features/`, `src/domain/` |
| **Lib / Infra** | 外部サービスとの接続（DB, API, 認証, ストレージ） | 外部ライブラリ | `lib/` |
| **Utils** | 純粋なヘルパー関数（ドメイン非依存） | なし（最下層） | `utils/` |

#### ビジネスロジックの分離（必須）

ビジネスロジック（計算・判定・変換・バリデーション）は **React / Next.js に依存しない純粋な TypeScript 関数** として切り出すこと。

```typescript
// ❌ Bad: ビジネスロジックが React コンポーネントに埋め込まれている
function PriceDisplay({ price, taxRate }: Props) {
  const tax = price * taxRate;          // ← ビジネスロジック
  const total = price + tax;            // ← ビジネスロジック
  return <span>{total.toLocaleString()}円</span>;
}

// ✅ Good: ビジネスロジックを純粋関数に分離
// features/pricing/calculate-tax.ts
export function calculateTotalWithTax(price: number, taxRate: number): number {
  return price + price * taxRate;
}

// UI はロジックを呼ぶだけ
function PriceDisplay({ price, taxRate }: Props) {
  const total = calculateTotalWithTax(price, taxRate);
  return <span>{total.toLocaleString()}円</span>;
}
```

**根拠:** ビジネスロジックを分離することで、(1) ユニットテストが容易になる、(2) 複数の UI（Web/API/CLI）から再利用可能になる、(3) フレームワーク移行時の影響範囲が最小化される。

#### ユビキタス言語（DDD Lite）

コード内の命名は、ビジネス上の用語と一致させること。

```typescript
// ❌ Bad: 汎用的すぎる命名
interface DataModel { ... }
function processItem(data: DataModel) { ... }

// ✅ Good: ビジネス用語と一致
interface Invoice { ... }
function calculateInvoiceTotal(invoice: Invoice) { ... }
```

### 2.2 推奨ディレクトリ構造（Feature-First + Colocation）

Next.js App Router の特性を活かし、**Feature-First（機能ドメインごとの整理）** と **Colocation（使う場所の近くに配置）** を基本方針とする。

```
frontend/src/
├── app/                          # ルーティング（App Router）
│   ├── (marketing)/              # Route Group（URL に影響しない）
│   │   ├── page.tsx
│   │   └── _components/          # このルート専用のコンポーネント
│   ├── (app)/                    # アプリケーション領域
│   │   ├── dashboard/
│   │   │   ├── page.tsx
│   │   │   ├── _components/      # ダッシュボード専用 UI
│   │   │   └── _actions/         # Server Actions（このルート専用）
│   │   └── layout.tsx
│   ├── api/                      # Route Handlers
│   ├── layout.tsx                # ルートレイアウト
│   ├── not-found.tsx             # カスタム 404
│   └── error.tsx                 # エラーページ
│
├── features/                     # ドメイン/機能ごとのモジュール
│   ├── auth/                     # 認証ドメイン
│   │   ├── components/           # 認証関連 UI
│   │   ├── hooks/                # 認証関連カスタム Hook
│   │   ├── actions/              # Server Actions
│   │   ├── constants.ts          # 定数
│   │   └── types.ts              # 型定義
│   ├── contact/                  # お問い合わせドメイン
│   └── portfolio/                # ポートフォリオドメイン
│
├── components/                   # グローバル共通 UI プリミティブ
│   └── ui/                       # Button, Input, Card 等
│
├── lib/                          # インフラ層（外部サービス接続）
│   ├── db.ts                     # DB クライアント
│   ├── auth.ts                   # 認証プロバイダ
│   └── email.ts                  # メール送信
│
├── utils/                        # 純粋ヘルパー関数（ドメイン非依存）
│   ├── format-date.ts
│   └── cn.ts                     # className ユーティリティ
│
└── types/                        # グローバル型定義
```

#### コロケーションルール

| コンポーネントの利用範囲 | 配置場所 |
|---|---|
| **1つのルートでのみ使用** | `app/[route]/_components/` に配置 |
| **同一ドメイン内で共有** | `features/[domain]/components/` に配置 |
| **ドメイン横断で全体共有** | `components/` に配置 |

#### Server / Client 境界

- **デフォルトは Server Component** とする。`"use client"` は必要最小限のコンポーネントにのみ付与する
- Server Component でデータ取得・ビジネスロジック実行を行い、Client Component はインタラクション（フォーム操作、アニメーション等）に限定する
- Server Actions はミューテーション（データ変更）の標準的な手段として使用する

---

## 3. DB設計規約

### 3.1 論理削除（Soft Delete）

ビジネスデータを扱うテーブルは**原則として論理削除**を採用する。

**必須カラム（対象テーブル）:**

| カラム | 型 | 説明 |
|---|---|---|
| `deleted_at` | `TIMESTAMP NULL` | 削除日時（`NULL` = 有効、値あり = 削除済み） |

**適用ルール:**
- ビジネスデータ（ユーザー・注文・記事等）は原則 `deleted_at` を持つ
- ORM / クエリビルダ層で `deleted_at IS NULL` の自動フィルタを実装する（全クエリに手動追加しない）
- ユニーク制約が必要なカラムは `(column, deleted_at)` の複合ユニーク、または DB が対応していればパーシャルインデックス（`WHERE deleted_at IS NULL`）を使う
- 物理削除 API も用意し、GDPR 等の「削除権」行使時や個人情報の完全消去に対応できるようにする

**適用除外（論理削除が不要なテーブル）:**
- ログ / イベント / 監査証跡テーブル（追記専用で削除操作が無い）
- 一時データ / セッション / キャッシュテーブル（物理削除 or TTL で管理）
- マスタデータ（有効/無効フラグで管理する方が適切な場合）

**根拠:** 論理削除は誤操作時のデータ復旧、監査証跡の保全、外部キー参照の整合性維持の観点で広く採用されている定石パターン。ただし全テーブルへの一律適用は過剰であり、テーブルの性質に応じて判断する。

---

## 4. 環境戦略（運用）

- `dev / staging / production` の3環境を想定
- 基本は Git ブランチで環境にデプロイする運用
- 設定は環境変数で切替（アプリ内に環境依存ロジックを散らさない）

---

## 5. Docker前提（開発体験）

- dev server / test / lint をコンテナ内で完結できるようにする
- デフォルトポートは衝突しにくい値（例：43111）を採用し変更可能にする
- コンテナが利用する環境変数は `docker-compose.yml` に埋め込まず、リポジトリ直下の `.env` で管理し読み込む（秘密はコミットしない。`.env.example` をテンプレとして用意）

### 対応プラットフォーム

- macOS（Docker Desktop）
- Windows WSL2（Docker Desktop）

開発ツール・スクリプトはこの両環境で動作することを前提に実装する。

---

## 6. デプロイ先の選択肢（低ロックイン）

- コンテナを前提にすると移植性が上がる（Render/Vercel/AWS等へ）
  - **注意**: Render の Free Plan は SMTP ポート（25, 465, 587等）をブロックするため、メール送信機能が必要で無料枠を利用したい場合は Vercel の利用を推奨する。
- Next.js固有の最適化は利用してよいが、必要なら段階的に外せる設計にする

---

## 付録：設計リファレンス

- Robert C. Martin — Clean Architecture: A Craftsman's Guide to Software Structure and Design
- Eric Evans — Domain-Driven Design: Tackling Complexity in the Heart of Software
- Next.js — Project Structure and Organization
  https://nextjs.org/docs/app/getting-started/project-structure
- Vercel — How to Think About Security in Next.js
  https://nextjs.org/blog/security-nextjs-server-components-actions

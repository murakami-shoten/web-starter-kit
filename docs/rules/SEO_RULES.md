# SEO規約（SEO_RULES）

（作成日: 2026-01-27 JST）

---

## 1. 大原則

- Google推奨（Search Central）に整合する
- 「役に立つオリジナルなコンテンツ」「信頼性（運営者/連絡先/ポリシー）」を優先する
- テクニックよりも情報設計・内部リンク・構造化で土台を作る

参考:
- Google SEO Starter Guide
- sitemap/robots 運用
- Next.js の sitemap 機能

---

## 2. 技術SEOの必須要件（ベース実装で標準化）

### 2.1 インデックス
- `robots.txt` と `sitemap.xml` を用意する
- 重要ページが 200 を返す
- `noindex` の誤設定を防ぐ

### 2.2 メタ情報
- title / description を全ページに定義
- **原則として `title` / `description` などのテキスト情報は環境変数（例: `.env` → `NEXT_PUBLIC_SITE_TITLE`）で管理し、コードへのハードコードを避ける**
- canonical を一貫して設定（URL正規化）
- OGP/Twitter Card も標準実装（SNS運用を想定）

### 2.3 構造化データ
- Organization / WebSite / Breadcrumb など、必要最小限を標準化
- 検索結果表示（CTR改善）を意識

### 2.4 Core Web Vitals
- LCP/CLS/INP を意識した実装（画像最適化、不要JS削減など）
- 速度計測を品質ゲートに入れる（QUALITY_GATES参照）

---

## 3. E-E-A-T寄り（信頼性・法務）

- 会社/運営者情報、問い合わせ先、プライバシーポリシー等を必須ページとして用意
- 記事系は著者・更新日・根拠を明示できるテンプレを用意

---

## 4. コンテンツ運用（MDX）

- 記事はMDXで可搬性を確保（CONTENT_RULES参照）
- 画像/メディアは将来S3互換へ移せる設計（LOW_LOCKIN_RULES参照）

---

## 付録：主要リファレンス（一次情報）

- Google Search Central: SEO Starter Guide  
  https://developers.google.com/search/docs/fundamentals/seo-starter-guide
- Google Search Central: Search Essentials（旧ガイドラインの最新相当）  
  https://developers.google.com/search/docs/essentials
- Google Search Central: sitemaps / robots の基本  
  https://developers.google.com/search/docs/crawling-indexing/sitemaps/overview
  https://developers.google.com/search/docs/crawling-indexing/robots/intro
- Next.js: Metadata / sitemap / robots  
  https://nextjs.org/docs/app/api-reference/file-conventions/metadata/sitemap
  https://nextjs.org/docs/app/api-reference/file-conventions/metadata/robots

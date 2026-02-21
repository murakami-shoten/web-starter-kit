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
- **render-blocking リソースの管理**: CSS チャンクの合計サイズを監視し、特にフォント CSS が肥大化していないか確認する
- **フォント最適化**: CJK フォント使用時は PERFORMANCE_RULES を参照し、`next/font/google` を直接使用しない
- **PageSpeed Insights（モバイル）目標**:
  - Performance 70+ を目標（CJK フォントの構造的制約により 90+ は困難）
  - Accessibility 90+ / Best Practices 100 / SEO 100 は必達

### 2.5 エラーページ（カスタム404）
- **`app/not-found.tsx` を必ず作成**し、デフォルトの Next.js 404 ページを置き換える
- 要件:
  - サイト共通のナビゲーション（Header / Footer）を含め、他ページと一貫した外観にする
  - トップページ等への導線（リンク）を設置し、ユーザーがサイト内に留まれるようにする
  - 404 ステータスコードが正しく返されること
- 根拠: Google Search Central はカスタム404ページで「サイトの他の部分と一貫した外観」と「有用なリンク」の提供を推奨
- 期待効果: 直帰率の改善、クローラビリティの維持

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
- Google Search Central: カスタム404ページ  
  https://developers.google.com/search/docs/crawling-indexing/custom-404-page
- Next.js: Metadata / sitemap / robots  
  https://nextjs.org/docs/app/api-reference/file-conventions/metadata/sitemap
  https://nextjs.org/docs/app/api-reference/file-conventions/metadata/robots
- Next.js: not-found.tsx  
  https://nextjs.org/docs/app/api-reference/file-conventions/not-found

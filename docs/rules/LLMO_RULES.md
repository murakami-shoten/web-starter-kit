# LLMO規約（LLMO_RULES — LLM Optimization）

（作成日: 2026-02-16 JST）

---

## 1. 大原則

- SEO（検索エンジン最適化）に加え、**LLM による情報取得・推論時の最適化（LLMO）** を標準対策として位置づける
- AI クローラーやチャットボットがサイト情報を**効率的かつ正確に**取得できるよう、構造化された情報提供ファイルを公開する
- 既存の `robots.txt` / `sitemap.xml` / SEO 対策と**共存・補完**する位置づけとする

---

## 2. llms.txt の基本仕様

### 2.1 仕様の出典

- 提案者: Jeremy Howard 氏（2024年9月）
- 公式仕様: https://llmstxt.org/
- 詳細仕様（GitHub）: https://github.com/AnswerDotAI/llms-txt
- **注意**: 2026年時点では RFC 等による標準化はされていないが、Anthropic・Vercel 等の主要プラットフォームが採用しており、事実上の標準として普及が進んでいる

### 2.2 ファイルの種類

| ファイル | 内容 | 設置パス |
|---|---|---|
| `llms.txt` | サイト構造のサマリー（コンパクト版） | `/llms.txt` |
| `llms-full.txt` | 完全な詳細情報を含む展開版（任意） | `/llms-full.txt` |

### 2.3 ファイルフォーマット（必須構造）

ファイルは **Markdown 形式** で記述する。以下の順序で構成する:

1. **H1**: プロジェクト名またはサイト名（**必須**、唯一の必須セクション）
2. **引用ブロック（`>`）**: サイトの概要説明（推奨）
3. **補足情報**: 見出し以外の任意の Markdown（段落・リスト等）
4. **H2 セクション群**: 詳細情報へのリンクリスト（0個以上）

リンクリストの各項目は以下の形式:

```
- [リンクタイトル](URL): リンクの説明（任意）
```

`## Optional` セクションは特別な意味を持ち、コンテキストを短くしたい場合にスキップ可能な二次情報を格納する。

---

## 3. 必須要件（リリース時に実装）

### 3.1 `/llms.txt` の設置

- サイトルート（`/llms.txt`）に Markdown 形式のファイルを配置する
- Next.js の場合、`public/llms.txt` に静的ファイルとして配置するか、Route Handler で動的生成する
- 内容には以下を含めること:

| 項目 | 記載内容 |
|---|---|
| サイト名 (H1) | プロジェクト名・サイト名 |
| 概要（引用） | サイトの目的・事業概要 |
| 主要ページ | サービス紹介、会社情報、お問い合わせ等への Markdown リンク |
| サイトマップ参照 | `sitemap.xml` への参照 |
| 運営者情報 | 組織名・連絡先・信頼性に関する情報 |
| 言語 | サイトの対応言語（例: `ja`） |

### 3.2 構造化データとの連携

- 既に SEO_RULES で必須としている構造化データ（Organization / WebSite / Breadcrumb）の情報と **整合性** を保つ
- `llms.txt` 内の運営者情報が、構造化データの Organization と矛盾しないようにする

### 3.3 `robots.txt` との共存

- `robots.txt` に `llms.txt` への参照を追加することを推奨（例: コメントで記載）
- `robots.txt` の AI クローラー向けルールと `llms.txt` の指示が矛盾しないようにする

---

## 4. 推奨要件（段階的に実装）

### 4.1 `/llms-full.txt` の設置

- 詳細な情報を含む展開版ファイルを提供する（コンテンツ量が増えた段階で）
- 全ページの概要やサービス詳細、FAQ などを含める

### 4.2 AI クローラー制御情報の記載

大規模サイトやアクセス負荷が懸念される場合、以下の制御情報を `llms.txt` に含める:

| 項目 | 目的 | 記載例 |
|---|---|---|
| レート制限 | 過剰クロールの防止 | `crawl-delay`, `x-rate-limit` |
| リトライポリシー | エラー時の適切な再試行 | `x-error-retry-policy` |
| 正規URL | 正しいドメインへの誘導 | `x-canonical-url` |
| ライセンス | コンテンツ利用条件の明示 | `x-content-license`, `x-ai-training-policy` |
| 同時接続制限 | サーバー負荷の管理 | `x-concurrency-limit` |

### 4.3 ページ単位の Markdown 版提供

- LLM が効率的に読み取れるよう、主要ページの Markdown 版を提供することを検討する
- 仕様推奨: 各ページ URL に `.md` を付与した URL でアクセス可能にする（例: `/about.md`）

---

## 5. 実装タイミング

- **リリースチェックリストに組み込む**: `llms.txt` の設置確認を `RELEASE_CHECKLIST.md` の項目に追加する
- **工程**: SEO 対策（`robots.txt` / `sitemap.xml` / メタ情報 / 構造化データ）と同じタイミング（リリース前）に実装する
  - 理由: サイト構造・主要ページ・運営者情報が確定していないと正確な `llms.txt` が作成できないため
  - SEO とセットで実施することで、情報の整合性を保ちやすい

---

## 6. 禁止事項

- `llms.txt` に**虚偽の情報**や**実在しないページ**へのリンクを含めない
- 機密情報や非公開ページへの参照を含めない
- 構造化データ / SEO メタ情報と矛盾する内容を記載しない

---

## 7. 検証方法

- `llms.txt` が正しい Markdown として読み取れることを確認する
- 記載した URL が全て 200 を返すことを確認する
- LLM（ChatGPT / Claude 等）に `llms.txt` の内容を渡し、サイトについて正確に回答できるか手動テストする
- `llms.txt` ディレクトリサイト（ https://llmstxt.site/ ）への登録を検討する

---

## 付録：主要リファレンス（一次情報）

- llms.txt 公式仕様  
  https://llmstxt.org/
- llms.txt GitHub リポジトリ  
  https://github.com/AnswerDotAI/llms-txt
- llms.txt ディレクトリ（対応サイト一覧）  
  https://llmstxt.site/
  https://directory.llmstxt.cloud/
- 参考記事:
  - 急増するAIクローラー対策として「llms.txt」を導入してみた（DevelopersIO）  
    https://dev.classmethod.jp/articles/llms-txt-for-ai-crawlers/
  - LLMS.txt: AI時代のWebサイト最適化ガイド（Zenn）  
    https://zenn.dev/minedia/articles/llmtxt-in-action

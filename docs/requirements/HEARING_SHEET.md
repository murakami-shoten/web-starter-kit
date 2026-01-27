# ヒアリングシート（HEARING_SHEET）

このシートは **要件定義の入力フォーム** です。未記入がある場合、AIエージェントはユーザーへ質問して埋めます（推測で埋めない）。

- 目的: コーポレートサイト構築に必要な要件を漏れなく確定する
- 出力: `docs/requirements/projects/<project_slug>/REQUIREMENTS_<project_slug>.md`（テンプレ `REQUIREMENTS_TEMPLATE.md` を複製して作成）

（作成日: 2026-01-27 JST）

---

## 記入ルール

- 分からない項目は `TBD` と書く（空欄禁止）
- 重要度は `Must / Should / Could / Won't` のいずれか
- “国際標準 / Google推奨 / 定石”がある場合はそれを優先する

---

## 1. 目的・ゴール

| 質問 | 回答 | 重要度 |
|---|---|---|
| サイトの主目的（KPI） | TBD | Must |
| 主要ターゲット（顧客像） | TBD | Must |
| 提供サービス/強み（USP） | TBD | Must |
| コンバージョン（問い合わせ/見積/採用など） | TBD | Must |

---

## 2. サイト構成（サイトマップ）

| ページ | 目的 | 必須要素 | 重要度 |
|---|---|---|---|
| トップ | TBD | TBD | Must |
| サービス | TBD | TBD | Must |
| 実績/事例 | TBD | TBD | Should |
| 会社/プロフィール | TBD | TBD | Must |
| ブログ/記事 | TBD | TBD | Could |
| お問い合わせ | TBD | TBD | Must |
| プライバシーポリシー | TBD | TBD | Must |
| 免責/特商法（必要なら） | TBD | TBD | Could |

---

## 3. コンテンツ要件

| 質問 | 回答 | 重要度 |
|---|---|---|
| 必要なコンテンツ種類（文章/画像/動画/資料DL） | TBD | Must |
| 実績の掲載方針（守秘の扱い） | TBD | Should |
| 更新頻度（ブログ等） | TBD | Could |
| 著者情報/監修の扱い（E-E-A-T） | TBD | Should |

---

## 4. デザイン要件

| 質問 | 回答 | 重要度 |
|---|---|---|
| トーン&マナー（例：信頼/ミニマル/ポップ） | TBD | Must |
| ブランド要素（色/フォント/ロゴ） | TBD | Should |
| 参考サイトURL（3〜5件） | TBD | Should |
| 写真素材（自前/フリー/生成AI） | TBD | Should |

---

## 5. SEO要件（技術+運用）

| 質問 | 回答 | 重要度 |
|---|---|---|
| 主要キーワード/テーマ | TBD | Should |
| 記事運用（MDX前提で良いか） | TBD | Could |
| 構造化データ（Organization等） | TBD | Should |
| Search Console / GA4 導入 | TBD | Should |

---

## 6. セキュリティ要件

| 質問 | 回答 | 重要度 |
|---|---|---|
| セキュリティヘッダー/CSP の厳格度 | TBD | Must |
| フォームのスパム対策（reCAPTCHA等） | TBD | Could |
| レート制限 | TBD | Should |
| 依存脆弱性/secret検出を必須化 | TBD | Must |

---

## 7. アクセシビリティ

| 質問 | 回答 | 重要度 |
|---|---|---|
| 目標（例：WCAG 2.2 AAを目安） | TBD | Should |
| キーボード操作の要件 | TBD | Should |
| 代替テキスト（alt）必須範囲 | TBD | Should |

---

## 8. 運用・デプロイ

| 質問 | 回答 | 重要度 |
|---|---|---|
| デプロイ先候補（Vercel/Render等） | TBD | Should |
| 環境（dev/staging/prod） | TBD | Must |
| ブランチ→環境デプロイ方針 | TBD | Must |
| ログ閲覧方法（管理画面/外部） | TBD | Must |

---

## 9. 非機能要件

| 質問 | 回答 | 重要度 |
|---|---|---|
| パフォーマンス目標（CWVなど） | TBD | Should |
| 可用性（ダウン許容） | TBD | Could |
| バックアップ/復旧方針 | TBD | Should |
| 監視（必要度） | TBD | Could |

---

## 10. 受入基準（Doneの定義）

| 項目 | 基準 | 重要度 |
|---|---|---|
| 品質ゲート | QUALITY_GATES必須項目が全通過 | Must |
| SEO | sitemap/robots/メタが整備 | Must |
| セキュリティ | CSP/ヘッダーが有効 | Must |
| a11y | 重大違反が無い（目標に応じて） | Should |

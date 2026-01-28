# ヒアリングシート（HEARING_SHEET）

このシートは **要件定義の入力フォーム** です。未記入がある場合、AIエージェントはユーザーへ質問して埋めます（推測で埋めない）。

- 目的: コーポレートサイト構築に必要な要件を漏れなく確定する
- 出力: `docs/requirements/projects/<project_slug>/REQUIREMENTS_<project_slug>.md`（テンプレ `REQUIREMENTS_TEMPLATE.md` を複製して作成）

（作成日: 2026-01-27 JST）

---

## 記入ルール

- 分からない項目は `TBD` と書く（空欄禁止）
- **AIエージェントは、ユーザーへの質問を「一問一答」形式で行うこと（一度に大量の質問を列挙しない）**
- 重要度は `Must / Should / Could / Won't` のいずれか
- “国際標準 / Google推奨 / 定石”がある場合はそれを優先する
- APIキー・トークン等の秘密はシートに直接記載しない。取得状況と保管場所のみ記入し、実キーはローカルの `.env.tmp`（Git管理外）に記録する。未取得はTBDのまま残し、実装開始前に再確認する。

---

## 0. プロジェクト種別

ここでの選択によって、以降の提案内容（サイト構成など）を調整してください。

| 質問 | 回答 | 重要度 |
|---|---|---|
| サイト種別（コーポレート / LP / EC / メディア / Webアプリ / その他） | TBD | Must |
| （その他の場合）具体的な種別 | TBD | Should |

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

**※選択した「プロジェクト種別」に応じて、AIエージェントが適切な構成案を提示すること。**


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
| CMS選定（MicroCMS/Contentful/WordPress API等）※WPは公開APIのみ推奨 | TBD | Should |
| 下書きプレビュー機能の必要性（ヘッドレスCMS時は実装コスト増） | TBD | Should |
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
| クッキー同意（CMP/GDPR/改正電気通信事業法）の要否 | TBD | Should |

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
| メール送信プロバイダ（SendGrid/AWS SES/Gmail等） | TBD | Should |
| ログ閲覧方法（管理画面/外部） | TBD | Must |

---

## 9. 非機能要件

| 質問 | 回答 | 重要度 |
|---|---|---|
| パフォーマンス目標（CWVなど） | TBD | Should |
| 可用性（ダウン許容） | TBD | Could |
| バックアップ/復旧方針（CMS/外部サービス上のデータ含む） | TBD | Should |
| ソースコードのバックアップ運用（GitHub障害対策） | TBD | Should |
| 監視（必要度） | TBD | Could |
| E2Eテスト（重要導線の自動化）の要否 | TBD | Should |


---

## 10. フロント検証環境（実ブラウザ確認）

| 質問 | 回答 | 重要度 |
|---|---|---|
| ホストに Chrome + chrome-devtools-mcp を導入済みか | TBD | Must |
| 未導入ならセットアップしてよいか（バージョン変動の影響を避ける手順で案内） | TBD | Must |
| 実ブラウザ確認を行わない場合の代替手段（Playwrightスクショのみ等） | TBD | Should |

---

## 11. 受入基準（Doneの定義）

| 項目 | 基準 | 重要度 |
|---|---|---|
| 品質ゲート | QUALITY_GATES必須項目が全通過 | Must |
| SEO | sitemap/robots/メタが整備 | Must |
| セキュリティ | CSP/ヘッダーが有効 | Must |
| a11y | 重大違反が無い（目標に応じて） | Should |
